import bcrypt from "bcryptjs";
import mongoose from "mongoose";
import chalk from "chalk";
import { v4 as uuidv4 } from "uuid";

import {
  RoleRepository,
  AccountRepository,
  MembershipRequestRepository,
  SchoolRepository,
} from "../../repositories";

import { getModelByRoleName } from "../../../common/utils/roleToModelMap";
import { DefaultLogger } from "../../../common/utils/DefaultLogger";
import { getRoleValidator } from "../../../common/utils/roleValidatorMap";

import { StudentRegisterHandler } from "./handlers/StudentRegisterHandler";
import { TeacherRegisterHandler } from "./handlers/TeacherRegisterHandler";
import { SchoolAdminRegisterHandler } from "./handlers/SchoolAdminRegisterHandler";
import { IRegisterHandler } from "./handlers/IRegisterHandler";
import { ISchool } from "../../models";
import { StaffRegisterHandler } from "./handlers/StaffRegisterHandler";
import { HttpError } from "../../../common/utils/HttpError";
import {
  generateTokenPair,
  verifyRefreshToken,
  comparePassword,
  hashPassword,
  TokenPayload,
} from "../../../common/utils/JwtHelper";

class AuthJwtService {
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
   * Đăng ký user mới (không dùng Firebase Auth)
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
    const session = await mongoose.startSession();
    session.startTransaction();

    try {
      // 1️⃣ Kiểm tra role tồn tại
      const role = await this.roleRepository.findById(baseUserInfo.roleId);
      if (!role) throw new Error("Role không tồn tại");

      // 2️⃣ Validate schema
      const schema = getRoleValidator(role.name);
      schema.parse({ ...baseUserInfo, ...(specificInfo || {}) });

      // 3️⃣ Kiểm tra email đã tồn tại chưa
      const existingAccount = await this.accountRepository.findAccountByEmail(
        email
      );
      if (existingAccount) {
        throw new HttpError(400, "Email đã được sử dụng");
      }

      // 4️⃣ Tạo UUID thay vì Firebase UID
      const uid = uuidv4();

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
      const hashedPassword = await hashPassword(password);
      const account = await this.accountRepository.createAccount(
        {
          uid,
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
        action: "REGISTER_USER_JWT",
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
      console.error(chalk.red.bold("❌ [registerUser JWT] error:"), error);
      await session.abortTransaction();

      await this.logger.log({
        userId: "System",
        action: "REGISTER_USER_JWT_FAILED",
        roleSnapshot: baseUserInfo.roleId,
        metadata: { email, baseUserInfo, specificInfo, error: error.message },
      });

      throw error;
    } finally {
      session.endSession();
    }
  }

  /**
   * Đăng nhập bằng email/password, trả về tokens
   */
  async login(email: string, password: string) {
    try {
      // 1️⃣ Tìm account theo email
      const account = await this.accountRepository.findAccountByEmail(email);
      if (!account) {
        throw new HttpError(401, "Email hoặc mật khẩu không đúng");
      }

      // 2️⃣ Verify password với bcrypt
      const isPasswordValid = await comparePassword(password, account.password);
      if (!isPasswordValid) {
        throw new HttpError(401, "Email hoặc mật khẩu không đúng");
      }

      // 3️⃣ Lấy thông tin user và role
      const userId = account.userId as any;
      if (!userId) {
        throw new HttpError(404, "Không tìm thấy thông tin người dùng");
      }

      const roleInfo = userId.roleId as any;
      if (!roleInfo) {
        throw new HttpError(404, "Không tìm thấy thông tin role");
      }

      // 4️⃣ Tạo token payload
      const tokenPayload: TokenPayload = {
        userId: userId._id.toString(),
        email: account.email,
        roleName: roleInfo.name,
        roleId: roleInfo._id.toString(),
        schoolId: userId.schoolId?._id?.toString(),
        classId: userId.classId?._id?.toString(),
      };

      // 5️⃣ Tạo token pair
      const tokens = generateTokenPair(tokenPayload);

      // 6️⃣ Lưu refresh token vào DB
      await this.accountRepository.updateRefreshToken(
        userId._id.toString(),
        tokens.refreshToken
      );

      console.log(
        chalk.greenBright(
          `[LOGIN JWT ✅] User: ${userId._id}, Role: ${roleInfo.name}`
        )
      );

      return {
        user: {
          _id: userId._id,
          fullName: userId.fullName,
          email: account.email,
          isVerified: userId.isVerified,
          avatarUrl: userId.avatarUrl,
          roleId: {
            _id: roleInfo._id,
            name: roleInfo.name,
          },
          schoolId: userId.schoolId,
          classId: userId.classId,
        },
        accessToken: tokens.accessToken,
        refreshToken: tokens.refreshToken,
      };
    } catch (err) {
      throw err;
    }
  }

  /**
   * Refresh access token bằng refresh token
   */
  async refreshToken(refreshToken: string) {
    try {
      // 1️⃣ Verify refresh token
      let decoded: TokenPayload;
      try {
        decoded = verifyRefreshToken(refreshToken);
      } catch (err: any) {
        throw new HttpError(401, err.message || "Refresh token không hợp lệ");
      }

      // 2️⃣ Tìm account theo refresh token
      const account = await this.accountRepository.findByRefreshToken(
        refreshToken
      );
      if (!account) {
        throw new HttpError(401, "Refresh token không tồn tại hoặc đã hết hạn");
      }

      // 3️⃣ Lấy thông tin user
      const userId = account.userId as any;
      const roleInfo = userId?.roleId as any;

      if (!userId || !roleInfo) {
        throw new HttpError(404, "Không tìm thấy thông tin người dùng");
      }

      // 4️⃣ Tạo token pair mới
      const tokenPayload: TokenPayload = {
        userId: userId._id.toString(),
        email: account.email,
        roleName: roleInfo.name,
        roleId: roleInfo._id.toString(),
        schoolId: userId.schoolId?._id?.toString(),
        classId: userId.classId?._id?.toString(),
      };

      const tokens = generateTokenPair(tokenPayload);

      // 5️⃣ Cập nhật refresh token mới vào DB (rotation)
      await this.accountRepository.updateRefreshToken(
        userId._id.toString(),
        tokens.refreshToken
      );

      console.log(chalk.greenBright(`[REFRESH TOKEN ✅] User: ${userId._id}`));

      return {
        accessToken: tokens.accessToken,
        refreshToken: tokens.refreshToken,
      };
    } catch (err) {
      throw err;
    }
  }

  /**
   * Đổi mật khẩu (xác thực mật khẩu cũ)
   */
  async changePassword(
    actorId: string,
    oldPassword: string,
    newPassword: string
  ) {
    // Tìm tài khoản trong DB
    const account = await this.accountRepository.findAccountByUserId(actorId);
    if (!account) throw new HttpError(404, "Không tìm thấy tài khoản");

    // Verify mật khẩu cũ với bcrypt
    const isPasswordValid = await comparePassword(
      oldPassword,
      account.password
    );
    if (!isPasswordValid) {
      throw new HttpError(400, "Mật khẩu cũ không chính xác");
    }

    const session = await mongoose.startSession();
    session.startTransaction();

    try {
      // Hash mật khẩu mới
      const hashedNewPassword = await hashPassword(newPassword);

      // Cập nhật mật khẩu mới
      await this.accountRepository.updateAccountPassword(
        actorId,
        hashedNewPassword,
        { session }
      );

      // Xóa refresh token (bắt buộc đăng nhập lại)
      await this.accountRepository.updateRefreshToken(actorId, null, {
        session,
      });

      await session.commitTransaction();

      await this.logger.log({
        userId: actorId,
        action: "CHANGE_PASSWORD_JWT",
        targetId: actorId,
        metadata: { changed: true },
      });
    } catch (err) {
      await session.abortTransaction();

      await this.logger.log({
        userId: actorId,
        action: "CHANGE_PASSWORD_JWT_FAILED",
        targetId: actorId,
        metadata: { error: err },
      });

      throw err;
    } finally {
      session.endSession();
    }
  }

  /**
   * Quên mật khẩu (đặt mật khẩu mới)
   */
  async forgetPassword(actorId: string, newPassword: string) {
    const session = await mongoose.startSession();
    session.startTransaction();

    try {
      const hashedNewPassword = await hashPassword(newPassword);

      await this.accountRepository.updateAccountPassword(
        actorId,
        hashedNewPassword,
        { session }
      );

      // Xóa refresh token
      await this.accountRepository.updateRefreshToken(actorId, null, {
        session,
      });

      await session.commitTransaction();

      await this.logger.log({
        userId: actorId,
        action: "FORGET_PASSWORD_JWT",
        targetId: actorId,
        metadata: { changed: true },
      });
    } catch (err) {
      await session.abortTransaction();

      await this.logger.log({
        userId: actorId,
        action: "FORGET_PASSWORD_JWT_FAILED",
        targetId: actorId,
        metadata: { error: err },
      });

      throw err;
    } finally {
      session.endSession();
    }
  }

  /**
   * Lấy thông tin user từ userId (dùng khi reload app với access token)
   */
  async getMe(userId: string) {
    try {
      // Tìm account theo userId (có populate thông tin user và role)
      const account = await this.accountRepository.findUserByUserId(userId);
      if (!account) {
        throw new HttpError(404, "Không tìm thấy thông tin người dùng");
      }

      const userInfo = account.userId as any;
      if (!userInfo) {
        throw new HttpError(404, "Không tìm thấy thông tin người dùng");
      }

      const roleInfo = userInfo.roleId as any;
      if (!roleInfo) {
        throw new HttpError(404, "Không tìm thấy thông tin role");
      }

      console.log(
        chalk.greenBright(
          `[GET ME JWT ✅] User: ${userInfo._id}, Role: ${roleInfo.name}`
        )
      );

      return {
        _id: userInfo._id,
        fullName: userInfo.fullName,
        email: account.email,
        isVerified: userInfo.isVerified,
        avatarUrl: userInfo.avatarUrl,
        roleId: {
          _id: roleInfo._id,
          name: roleInfo.name,
        },
        schoolId: userInfo.schoolId,
        classId: userInfo.classId,
      };
    } catch (err) {
      throw err;
    }
  }

  /**
   * Logout - Xóa refresh token
   */
  async logout(userId: string) {
    try {
      await this.accountRepository.updateRefreshToken(userId, null);

      console.log(chalk.yellowBright(`[LOGOUT JWT] User: ${userId}`));

      await this.logger.log({
        userId,
        action: "LOGOUT_JWT",
        targetId: userId,
        metadata: {},
      });
    } catch (err) {
      throw err;
    }
  }
}

export default AuthJwtService;
