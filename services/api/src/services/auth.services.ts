import Role from "../models/Role";
import RoleRepository from "../repositories/role.repository";
import * as AccountRepo from "../repositories/account.repository";
import { getModelByRoleName } from "../utils/roleToModelMap";
import { DefaultLogger } from "../utils/DefaultLogger";
import { ILogger } from "../interfaces/logger.interface";
import admin from "firebase-admin";
import { getRoleValidator } from "../utils/roleValidatorMap";
import { ZodError } from "zod";
import bcrypt from "bcryptjs";

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
    // 1️⃣ Kiểm tra role tồn tại
    role = await roleRepository.findById(baseUserInfo.roleId);
    if (!role) throw new Error("Role không tồn tại");

    // 2️⃣ Validate dữ liệu theo role
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

    // 3️⃣ Tạo user trên Firebase
    fbUser = await admin.auth().createUser({ email, password });

    // 4️⃣ Tạo MongoDB User
    const UserModel = getModelByRoleName(role.name);
    user = await UserModel.create({
      ...baseUserInfo,
      ...specificInfo,
      roleId: role._id,
    });

    // 5️⃣ Tạo account + hash password
    const hashedPassword = await bcrypt.hash(password, 10);
    account = await AccountRepo.createAccount({
      uid: fbUser.uid,
      email,
      password: hashedPassword,
      userId: user._id,
    });

    // 6️⃣ Log thành công
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

    // 🔹 Rollback gọn: chỉ xóa nếu từng bước đã thành công
    const rollbackTasks = [
      fbUser ? admin.auth().deleteUser(fbUser.uid) : null,
      user
        ? getModelByRoleName(role?.name || "").deleteOne({ _id: user._id })
        : null,
      account ? AccountRepo.deleteAccountByUserId(user?._id) : null,
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
