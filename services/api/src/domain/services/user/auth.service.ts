import admin from "firebase-admin";
import { ZodError } from "zod";
import bcrypt from "bcryptjs";

import { Role } from "../../models";
import { RoleRepository, AccountRepository } from "../../repositories";

import { getModelByRoleName } from "../../../common/utils/roleToModelMap";
import { DefaultLogger } from "../../../common/utils/DefaultLogger";
import { getRoleValidator } from "../../../common/utils/roleValidatorMap";

class AuthService {
  private readonly roleRepository: RoleRepository;
  private readonly accountRepository: AccountRepository;
  private readonly logger: DefaultLogger;

  constructor(
    roleRepository: RoleRepository,
    accountRepository: AccountRepository,
    logger: DefaultLogger
  ) {
    this.roleRepository = roleRepository;
    this.accountRepository = accountRepository;
    this.logger = logger;
  }

  /**
   * Đăng ký user mới
   */
  async registerUser(
    email: string,
    password: string,
    baseUserInfo: any,
    specificInfo: any
  ) {
    let fbUser: admin.auth.UserRecord | null = null;
    let user: any = null;
    let account: any = null;
    let role: any = null;

    try {
      // 1. Check role tồn tại
      role = await this.roleRepository.findById(baseUserInfo.roleId);
      if (!role) throw new Error("Role không tồn tại");

      // 2. Validate theo schema của role
      const schema = getRoleValidator(role.name);
      try {
        schema.parse({ ...baseUserInfo, ...specificInfo });
      } catch (err) {
        if (err instanceof ZodError) {
          throw new Error(
            `Validation failed: ${err.issues.map((e) => e.message).join(", ")}`
          );
        }
        throw err;
      }

      // 3. Firebase
      fbUser = await admin.auth().createUser({ email, password });

      // 4. MongoDB User
      const UserModel = getModelByRoleName(role.name);
      user = await UserModel.create({
        ...baseUserInfo,
        ...specificInfo,
        roleId: role._id,
      });

      // 5. Account (hash password)
      const hashedPassword = await bcrypt.hash(password, 10);
      account = await this.accountRepository.createAccount({
        uid: fbUser.uid,
        email,
        password: hashedPassword,
        userId: user._id,
      });

      // 6. Log
      await this.logger.log({
        userId: user._id.toString(),
        action: "REGISTER_USER",
        targetId: user._id.toString(),
        roleSnapshot: role.name,
        metadata: { email, baseUserInfo, specificInfo },
      });

      return { account };
    } catch (error: any) {
      console.error("❌ [registerUser] error:", error);

      // Rollback
      const rollbackTasks = [
        fbUser ? admin.auth().deleteUser(fbUser.uid) : null,
        user
          ? getModelByRoleName(role?.name || "").deleteOne({ _id: user._id })
          : null,
        account
          ? this.accountRepository.deleteAccountByUserId(user?._id)
          : null,
      ].filter(Boolean) as Promise<any>[];

      if (rollbackTasks.length) {
        await Promise.allSettled(rollbackTasks);
        console.log("Rollback completed");
      }

      await this.logger.log({
        userId: "System",
        action: "REGISTER_USER_FAILED",
        roleSnapshot: baseUserInfo.roleId,
        metadata: { email, baseUserInfo, specificInfo, error: error.message },
      });

      throw error;
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

    let firebaseUpdated = false;
    let backendUpdated = false;

    try {
      await admin.auth().updateUser(account.uid, { password: newPassword });
      firebaseUpdated = true;

      await this.accountRepository.updateAccountPassword(
        actorId,
        hashedNewPassword
      );
      backendUpdated = true;

      await this.logger.log({
        userId: actorId,
        action: "CHANGE_PASSWORD",
        targetId: actorId,
        metadata: { oldPassword, newPassword },
      });
    } catch (err) {
      await this.logger.log({
        userId: actorId,
        action: "CHANGE_PASSWORD_FAILED",
        targetId: actorId,
        metadata: { oldPassword, newPassword },
      });

      // rollback
      if (firebaseUpdated && !backendUpdated) {
        await admin.auth().updateUser(account.uid, { password: oldPassword });
      }
      if (!firebaseUpdated && backendUpdated) {
        await this.accountRepository.updateAccountPassword(
          actorId,
          account.password
        );
      }
      throw err;
    }
  }

  /**
   * Quên mật khẩu
   */
  async forgetPassword(actorId: string, newPassword: string) {
    try {
      const hashedNewPassword = await bcrypt.hash(newPassword, 10);
      await this.accountRepository.updateAccountPassword(
        actorId,
        hashedNewPassword
      );

      await this.logger.log({
        userId: actorId,
        action: "FORGET_PASSWORD",
        targetId: actorId,
        metadata: { newPassword },
      });
    } catch (err) {
      await this.logger.log({
        userId: actorId,
        action: "FORGET_PASSWORD_FAILED",
        targetId: actorId,
        metadata: { newPassword },
      });

      throw err;
    }
  }
}

export default AuthService;
