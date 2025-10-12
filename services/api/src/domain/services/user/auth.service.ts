import admin from "firebase-admin";
import bcrypt from "bcryptjs";
import mongoose from "mongoose";
import chalk from "chalk";
import axios from "axios";

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
import { HttpError } from "../../../common/utils/HttpError";

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
    let copiedAvatar = false;
    const avatarPath = baseUserInfo.avatarPath;

    const session = await mongoose.startSession();
    session.startTransaction();

    try {
      // 1️⃣ Kiểm tra role tồn tại
      const role = await this.roleRepository.findById(baseUserInfo.roleId);
      if (!role) throw new Error("Role không tồn tại");

      // 2️⃣ Validate schema
      const schema = getRoleValidator(role.name);
      schema.parse({ ...baseUserInfo, ...(specificInfo || {}) });

      // 3️⃣ Tạo user Firebase
      fbUser = await admin.auth().createUser({ email, password });

      // 4️⃣ Copy avatar nếu có
      if (avatarPath) {
        const bucket = admin.storage().bucket();
        const src = bucket.file(avatarPath);
        const destPath = `avatar_user/${fbUser.uid}`;
        const dest = bucket.file(destPath);

        try {
          await src.copy(dest);
          copiedAvatar = true;
          await src.delete(); // Xoá file tạm

          // 🧠 Lấy download URL mới
          const [url] = await dest.getSignedUrl({
            action: "read",
            expires: "03-09-2491", // gần như vĩnh viễn
          });

          // ✅ Cập nhật lại baseUserInfo để lưu vào DB
          baseUserInfo.avatarPath = destPath;
          baseUserInfo.avatarUrl = url;
        } catch (err) {
          console.error("❌ Lỗi copy avatar:", err);
          throw new Error("Không thể lưu avatar, vui lòng thử lại");
        }
      }

      // 5️⃣ Tạo user trong MongoDB
      const UserModel = getModelByRoleName(role.name);
      const [user] = await UserModel.create(
        [
          {
            ...baseUserInfo,
            ...specificInfo,
            email,
            roleId: role._id,
          },
        ],
        { session }
      );

      // 6️⃣ Hash & lưu account
      const hashedPassword = await bcrypt.hash(password, 10);
      const account = await this.accountRepository.createAccount(
        {
          uid: fbUser.uid,
          email,
          password: hashedPassword,
          userId: user._id,
        },
        { session }
      );

      // 7️⃣ Logic riêng theo role
      const handler = this.handlers[role.name] ?? this.handlers["Staff"];
      if (handler) {
        await handler.handle(user, { schoolData, schoolId, classId }, session);
      }

      await session.commitTransaction();

      await this.logger.log({
        userId: user._id?.toString(),
        action: "REGISTER_USER",
        targetId: user._id.toString(),
        roleSnapshot: role.name,
        metadata: { email, baseUserInfo, specificInfo },
      });

      return {
        account,
        filePath: baseUserInfo.avatarPath,
        url: baseUserInfo.avatarUrl,
      };
    } catch (error: any) {
      console.error(chalk.red.bold("❌ [registerUser] error:"), error);
      await session.abortTransaction();

      const bucket = admin.storage().bucket();

      // Rollback Firebase user
      if (fbUser) {
        try {
          await admin.auth().deleteUser(fbUser.uid);
        } catch (fbErr) {
          console.error("⚠️ Rollback Firebase user thất bại:", fbErr);
        }
      }

      // Rollback file avatar
      try {
        if (copiedAvatar && fbUser) {
          await bucket
            .file(`avatar_user/${fbUser.uid}`)
            .delete({ ignoreNotFound: true });
        }
        if (avatarPath) {
          await bucket.file(avatarPath).delete({ ignoreNotFound: true });
        }
      } catch (fileErr) {
        console.error("⚠️ Rollback file thất bại:", fileErr);
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
   * Đổi mật khẩu (xác thực mật khẩu cũ trực tiếp với Firebase)
   */
  async changePassword(
    actorId: string,
    oldPassword: string,
    newPassword: string
  ) {
    // Tìm tài khoản trong DB
    const account = await this.accountRepository.findAccountByUserId(actorId);
    if (!account) throw new Error("Không tìm thấy tài khoản");
    const email = account?.email;

    // --- B1: Xác thực mật khẩu cũ với Firebase ---
    let idToken: string;
    try {
      const firebaseApiKey = process.env.FIREBASE_API_KEY;
      const verifyUrl = `https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=${firebaseApiKey}`;

      const response = await axios.post(verifyUrl, {
        email,
        password: oldPassword,
        returnSecureToken: true,
      });

      idToken = response.data.idToken;
    } catch (err) {
      throw new HttpError(400, "Mật khẩu cũ không chính xác");
    }

    // --- B2: Hash mật khẩu mới để lưu DB ---
    const hashedNewPassword = await bcrypt.hash(newPassword, 10);

    // --- B3: Chuẩn bị transaction ---
    const session = await mongoose.startSession();
    session.startTransaction();

    let firebaseUpdated = false;

    try {
      // --- B4: Cập nhật mật khẩu trên Firebase ---
      await admin.auth().updateUser(account.uid, { password: newPassword });
      firebaseUpdated = true;

      // --- B5: Đồng bộ DB ---
      await this.accountRepository.updateAccountPassword(
        actorId,
        hashedNewPassword,
        { session }
      );

      // --- B6: Commit DB ---
      await session.commitTransaction();

      // --- B7: Ghi log thành công ---
      await this.logger.log({
        userId: actorId,
        action: "CHANGE_PASSWORD",
        targetId: actorId,
        metadata: {
          firebaseVerified: true,
          firebaseUpdated: true,
          changed: true,
        },
      });
    } catch (err) {
      await session.abortTransaction();

      // --- Rollback Firebase nếu DB fail ---
      if (firebaseUpdated) {
        try {
          await admin.auth().updateUser(account.uid, { password: oldPassword });
        } catch (rollbackErr) {}
      }

      // --- Ghi log lỗi ---
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
