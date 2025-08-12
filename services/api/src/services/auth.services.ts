import Role from "../models/Role";
import RoleRepository from "../repositories/role.repository";
import * as AccountRepo from "../repositories/account.repository";
import { getModelByRoleName } from "../utils/roleToModelMap";
import { DefaultLogger } from "../utils/DefaultLogger";
import { ILogger } from "../interfaces/logger.interface";
import admin from "firebase-admin"; // Firebase Admin SDK

const roleRepository = new RoleRepository(Role);
const logger: ILogger = new DefaultLogger();

/**
 * Tạo user mới trên Firebase + MongoDB
 */
export const registerUser = async (
  email: string,
  password: string,
  roleId: string,
  baseUserInfo: any,
  specificInfo: any
) => {
  try {
    // 1. Lấy thông tin role
    const role = await roleRepository.findById(roleId);
    if (!role) throw new Error("❌ Vai trò không tồn tại");

    const UserModel = getModelByRoleName(role.name);

    // 2. Tạo user trên Firebase
    const fbUser = await admin.auth().createUser({
      email,
      password,
      emailVerified: false,
      disabled: false,
    });

    // 3. Tạo hồ sơ user trong MongoDB
    const user = await UserModel.create({
      ...baseUserInfo,
      ...specificInfo,
      roleId: role._id,
    });

    // 4. Tạo account mapping Firebase UID ↔ MongoDB UserId
    const account = await AccountRepo.createAccount({
      uid: fbUser.uid,
      email,
      userId: user._id,
    });

    // 5. Log thành công
    await logger.log({
      userId: user._id.toString(),
      action: "REGISTER_USER",
      targetId: user._id.toString(),
      roleSnapshot: role.name,
      metadata: {
        email,
        roleId,
        baseUserInfo,
        specificInfo,
      },
    });

    return { account, user, firebaseUser: fbUser };
  } catch (error) {
    // Log thất bại
    await logger.log({
      userId: "System",
      action: "REGISTER_USER_FAILED",
      roleSnapshot: roleId,
      metadata: {
        email,
        roleId,
        baseUserInfo,
        specificInfo,
        error: (error as Error).message,
      },
    });

    throw error;
  }
};
