import admin from "firebase-admin";
import { ZodError } from "zod";
import bcrypt from "bcryptjs";
import mongoose from "mongoose";
import chalk from "chalk";

import {
  RoleRepository,
  AccountRepository,
  MembershipRequestRepository,
  SchoolRepository,
} from "../../repositories";

import { getModelByRoleName } from "../../../common/utils/roleToModelMap";
import { DefaultLogger } from "../../../common/utils/DefaultLogger";
import { getRoleValidator } from "../../../common/utils/roleValidatorMap";

import { getFirebaseAuthErrorMessage } from "../../../common/utils/firebaseHelper";
import { StudentRegisterHandler } from "./handlers/StudentRegisterHandler";
import { TeacherRegisterHandler } from "./handlers/TeacherRegisterHandler";
import { SchoolAdminRegisterHandler } from "./handlers/SchoolAdminRegisterHandler";
import { IRegisterHandler } from "./handlers/IRegisterHandler";
import { ISchool } from "../../models";
import { StaffRegisterHandler } from "./handlers/StaffRegisterHandler";

class AuthService {
  private readonly roleRepository: RoleRepository;
  private readonly accountRepository: AccountRepository;
  private readonly logger: DefaultLogger;
  private readonly membershipRepository: MembershipRequestRepository;
  private readonly schoolRepository: SchoolRepository;

  private readonly handlers: Record<string, IRegisterHandler>;

  constructor(
    roleRepository: RoleRepository,
    accountRepository: AccountRepository,
    logger: DefaultLogger,
    membershipRepository: MembershipRequestRepository,
    schoolRepository: SchoolRepository
  ) {
    this.roleRepository = roleRepository;
    this.accountRepository = accountRepository;
    this.logger = logger;
    this.membershipRepository = membershipRepository;
    this.schoolRepository = schoolRepository;

    this.handlers = {
      Student: new StudentRegisterHandler(this.membershipRepository),
      Teacher: new TeacherRegisterHandler(this.membershipRepository),
      SchoolAdmin: new SchoolAdminRegisterHandler(
        this.schoolRepository,
        this.membershipRepository
      ),
      Staff: new StaffRegisterHandler(this.membershipRepository),
    };
  }

  /**
   * Đăng ký user mới
   */
  async registerUser(
    email: string,
    password: string,
    schoolId: string,
    classId: string,
    baseUserInfo: any,
    specificInfo: any,
    schoolData?: Partial<ISchool>
  ) {
    let fbUser: admin.auth.UserRecord | null = null;
    let user: any = null;
    let account: any = null;
    let role: any = null;

    const session = await mongoose.startSession();
    session.startTransaction();

    try {
      // 1. Check role tồn tại
      role = await this.roleRepository.findById(baseUserInfo.roleId);
      if (!role) throw new Error("Role không tồn tại");

      // 2. Validate theo schema của role
      const schema = getRoleValidator(role.name);
      try {
        schema.parse({ ...baseUserInfo, ...(specificInfo || {}) });
      } catch (err) {
        throw err;
      }

      // 3. Firebase
      fbUser = await admin.auth().createUser({ email, password });

      // 4. MongoDB User
      const UserModel = getModelByRoleName(role.name);
      user = await UserModel.create(
        [
          {
            ...baseUserInfo,
            ...specificInfo,
            email: email,
            roleId: role._id,
          },
        ],
        { session }
      );
      user = user[0];

      // 5. Account (hash password)
      const hashedPassword = await bcrypt.hash(password, 10);
      account = await this.accountRepository.createAccount(
        {
          uid: fbUser.uid,
          email,
          password: hashedPassword,
          userId: user._id,
        },
        { session }
      );

      // 6. Business logic theo role (Student/Teacher/SchoolAdmin)
      const handler = this.handlers[role.name] ?? this.handlers["Staff"];
      if (handler) {
        await handler.handle(
          user,
          {
            schoolData: schoolData,
            schoolId: schoolId,
            classId: classId, // optional
          },
          session
        );
      }

      // 7. Commit transaction
      await session.commitTransaction();

      // 8. Log
      await this.logger.log({
        userId: user._id?.toString(),
        action: "REGISTER_USER",
        targetId: user._id.toString(),
        roleSnapshot: role.name,
        metadata: { email, baseUserInfo, specificInfo },
      });

      return { account };
    } catch (error: any) {
      console.error(
        chalk.red.bold("❌ [registerUser] error:"),
        chalk.yellow(error instanceof Error ? error.message : String(error))
      );

      // Rollback MongoDB
      await session.abortTransaction();

      // Rollback Firebase nếu đã tạo user
      if (fbUser) {
        try {
          await admin.auth().deleteUser(fbUser.uid);
          console.log("Delete user tren fb");
        } catch (fbErr) {
          console.error(
            chalk.red.bold("❌ Rollback Firebase failed:"),
            chalk.yellow(fbErr)
          );
        }
      }

      await this.logger.log({
        userId: "System",
        action: "REGISTER_USER_FAILED",
        roleSnapshot: baseUserInfo.roleId,
        metadata: { email, baseUserInfo, specificInfo, error: error.message },
      });

      if (error.code) {
        throw new Error(getFirebaseAuthErrorMessage(error.code));
      }

      throw error;
    } finally {
      session.endSession();
    }
  }
  /**
   * Đổi mật khẩu
   */
  async changePassword(
    actorId: string,
    oldPassword: string,
    newPassword: string
  ) {
    const account = await this.accountRepository.findAccountByUserId(actorId);
    if (!account) throw new Error("Không tìm thấy tài khoản");

    const isMatch = await bcrypt.compare(oldPassword, account.password);
    if (!isMatch) throw new Error("Mật khẩu cũ không chính xác");

    const hashedNewPassword = await bcrypt.hash(newPassword, 10);

    const session = await mongoose.startSession();
    session.startTransaction();

    let firebaseUpdated = false;

    try {
      // B1: update Firebase
      await admin.auth().updateUser(account.uid, { password: newPassword });
      firebaseUpdated = true;

      // B2: update Mongo (có session)
      await this.accountRepository.updateAccountPassword(
        actorId,
        hashedNewPassword,
        { session }
      );

      // Commit DB
      await session.commitTransaction();

      // Log
      await this.logger.log({
        userId: actorId,
        action: "CHANGE_PASSWORD",
        targetId: actorId,
        metadata: { changed: true },
      });
    } catch (err) {
      await session.abortTransaction();

      // rollback Firebase nếu DB fail
      if (firebaseUpdated) {
        await admin.auth().updateUser(account.uid, { password: oldPassword });
      }

      await this.logger.log({
        userId: actorId,
        action: "CHANGE_PASSWORD_FAILED",
        targetId: actorId,
        metadata: { error: err },
      });

      throw err;
    } finally {
      session.endSession();
    }
  }

  /**
   * Quên mật khẩu
   */
  async forgetPassword(actorId: string, newPassword: string) {
    const session = await mongoose.startSession();
    session.startTransaction();

    try {
      const hashedNewPassword = await bcrypt.hash(newPassword, 10);

      await this.accountRepository.updateAccountPassword(
        actorId,
        hashedNewPassword,
        { session }
      );

      await session.commitTransaction();

      await this.logger.log({
        userId: actorId,
        action: "FORGET_PASSWORD",
        targetId: actorId,
        metadata: { changed: true },
      });
    } catch (err) {
      await session.abortTransaction();

      await this.logger.log({
        userId: actorId,
        action: "FORGET_PASSWORD_FAILED",
        targetId: actorId,
        metadata: { error: err },
      });

      throw err;
    } finally {
      session.endSession();
    }
  }

  /**
   * Đăng nhập
   */
  async login(uid: string) {
    try {
      const user = await this.accountRepository.findUserByUid(uid);

      return user;
    } catch (err) {
      throw err;
    }
  }
}

export default AuthService;
