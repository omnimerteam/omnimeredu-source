import admin from "firebase-admin";
import { ZodError } from "zod";
import bcrypt from "bcryptjs";

import { Role } from "../../models";
import { RoleRepository, AccountRepository } from "../../repositories";

import { getModelByRoleName } from "../../../common/utils/roleToModelMap";
import { DefaultLogger } from "../../../common/utils/DefaultLogger";
import { getRoleValidator } from "../../../common/utils/roleValidatorMap";
import { ILogger } from "../../../common/interfaces/logger.interface";

const roleRepository = new RoleRepository(Role);
const logger: ILogger = new DefaultLogger();

interface RegisterResult {
  account: any;
  user: any;
  firebaseUser: admin.auth.UserRecord;
}

export const registerUser = async (
  email: string,
  password: string,
  baseUserInfo: any,
  specificInfo: any
): Promise<RegisterResult> => {
  let fbUser: admin.auth.UserRecord | null = null;
  let user: any = null;
  let account: any = null;
  let role: any = null;

  try {
    // 1. Kiểm tra role tồn tại
    role = await roleRepository.findById(baseUserInfo.roleId);
    if (!role) throw new Error("Role không tồn tại");

    // 2️. Validate dữ liệu theo role
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

    // 3️. Tạo user trên Firebase
    fbUser = await admin.auth().createUser({ email, password });

    // 4️. Tạo MongoDB User
    const UserModel = getModelByRoleName(role.name);
    user = await UserModel.create({
      ...baseUserInfo,
      ...specificInfo,
      roleId: role._id,
    });

    // 5️. Tạo account + hash password
    const hashedPassword = await bcrypt.hash(password, 10);
    account = await AccountRepository.createAccount({
      uid: fbUser.uid,
      email,
      password: hashedPassword,
      userId: user._id,
    });

    // 6️. Log thành công
    await logger.log({
      userId: user._id.toString(),
      action: "REGISTER_USER",
      targetId: user._id.toString(),
      roleSnapshot: role.name,
      metadata: { email, baseUserInfo, specificInfo },
    });

    return { account, user, firebaseUser: fbUser };
  } catch (error: any) {
    console.error("❌ [registerUser] error:", error);

    // Rollback gọn: chỉ xóa nếu từng bước đã thành công
    const rollbackTasks = [
      fbUser ? admin.auth().deleteUser(fbUser.uid) : null,
      user
        ? getModelByRoleName(role?.name || "").deleteOne({ _id: user._id })
        : null,
      account ? AccountRepository.deleteAccountByUserId(user?._id) : null,
    ].filter(Boolean) as Promise<any>[];

    if (rollbackTasks.length) {
      await Promise.allSettled(rollbackTasks).then((results) => {
        results.forEach((r, i) => {
          if (r.status === "rejected") {
            console.error(`Rollback task #${i} failed:`, r.reason);
          }
        });
      });
      console.log("Rollback completed for any created resources");
    }

    // 🔹 Log thất bại
    await logger.log({
      userId: "System",
      action: "REGISTER_USER_FAILED",
      roleSnapshot: baseUserInfo.roleId,
      metadata: { email, baseUserInfo, specificInfo, error: error.message },
    });

    throw error;
  }
};

export const changePassword = async (
  actorId: string,
  oldPassword: string,
  newPassword: string
) => {
  const account = await AccountRepository.findAccountByUserId(actorId);
  if (!account) throw new Error("Không tìm thấy tài khoản");

  // Kiểm tra mật khẩu cũ
  const isMatch = await bcrypt.compare(oldPassword, account.password);
  if (!isMatch) throw new Error("Mật khẩu cũ không chính xác");

  const hashedNewPassword = await bcrypt.hash(newPassword, 10);

  // Đồng bộ Firebase + backend
  let firebaseUpdated = false;
  let backendUpdated = false;

  try {
    // Cập nhật Firebase
    await admin.auth().updateUser(account.uid, { password: newPassword });
    firebaseUpdated = true;

    // Cập nhật backend
    await AccountRepository.updateAccountPassword(actorId, hashedNewPassword);
    backendUpdated = true;

    await logger.log({
      userId: actorId,
      action: "CHANGE_PASSWORD",
      targetId: actorId,
      metadata: { oldPassword, newPassword },
    });
  } catch (err) {
    await logger.log({
      userId: actorId,
      action: "CHANGE_PASSWORD_FAILED",
      targetId: actorId,
      metadata: { oldPassword, newPassword },
    });

    // Rollback nếu 1 trong 2 bước lỗi
    if (firebaseUpdated && !backendUpdated) {
      // rollback Firebase về password cũ
      await admin.auth().updateUser(account.uid, { password: oldPassword });
    }
    if (!firebaseUpdated && backendUpdated) {
      // rollback backend về password cũ
      await AccountRepository.updateAccountPassword(actorId, account.password);
    }
    throw err;
  }
};

export const forgetPassword = async (actorId: string, newPassword: string) => {
  try {
    const hashedNewPassword = await bcrypt.hash(newPassword, 10);
    await AccountRepository.updateAccountPassword(actorId, hashedNewPassword);

    await logger.log({
      userId: actorId,
      action: "FORGET_PASSWORD",
      targetId: actorId,
      metadata: { newPassword },
    });
  } catch (err) {
    await logger.log({
      userId: actorId,
      action: "FORGET_PASSWORD_FAILED",
      targetId: actorId,
      metadata: { newPassword },
    });

    throw err;
  }
};
