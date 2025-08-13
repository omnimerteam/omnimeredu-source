import Role from "../models/Role";
import RoleRepository from "../repositories/role.repository";
import * as AccountRepo from "../repositories/account.repository";
import { getModelByRoleName } from "../utils/roleToModelMap";
import { DefaultLogger } from "../utils/DefaultLogger";
import { ILogger } from "../interfaces/logger.interface";
import admin from "firebase-admin"; // Firebase Admin SDK
import { getRoleValidator } from "../utils/roleValidatorMap";
import { ZodError } from "zod";
import bcrypt from "bcryptjs";

const roleRepository = new RoleRepository(Role);
const logger: ILogger = new DefaultLogger();

/**
 * Tạo user mới trên Firebase + MongoDB
 */
export const registerUser = async (
  email: string,
  password: string,
  baseUserInfo: any,
  specificInfo: any
) => {
  let fbUser: admin.auth.UserRecord | null = null;
  let user: any = null;

  try {
    // 1️: Kiểm tra roleId tồn tại
    const role = await roleRepository.findById(baseUserInfo.roleId);
    if (!role) throw new Error("Role không tồn tại");

    // 2️: Validate dữ liệu theo role
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

    // 3️: Tạo user trên Firebase
    fbUser = await admin.auth().createUser({ email, password });

    // 4️: Tạo MongoDB User
    const UserModel = getModelByRoleName(role.name);
    user = await UserModel.create({
      ...baseUserInfo,
      ...specificInfo,
      roleId: role._id,
    });

    // 5️: Tạo account mapping Firebase UID ↔ MongoDB userId
    const saltRounds = 10;
    const hashedPassword = await bcrypt.hash(password, saltRounds);
    const account = await AccountRepo.createAccount({
      uid: fbUser.uid,
      email,
      password: hashedPassword,
      userId: user._id,
    });

    // 6️: Log thành công
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

    // --- ROLLBACK nếu đã tạo Firebase user ---
    if (fbUser) {
      try {
        await admin.auth().deleteUser(fbUser.uid);
        console.log("Rollback: Firebase user deleted");
      } catch (e) {
        console.error("Rollback Firebase delete failed:", e);
      }
    }

    // --- ROLLBACK nếu đã tạo MongoDB user ---
    if (user) {
      try {
        const UserModel = getModelByRoleName(baseUserInfo.roleId); // lấy model theo roleId
        await UserModel.deleteOne({ _id: user._id });
        console.log("Rollback: MongoDB user deleted");
      } catch (e) {
        console.error("Rollback MongoDB delete failed:", e);
      }
    }

    // Log thất bại
    await logger.log({
      userId: "System",
      action: "REGISTER_USER_FAILED",
      roleSnapshot: baseUserInfo.roleId,
      metadata: { email, baseUserInfo, specificInfo, error: error.message },
    });

    throw error;
  }
};
