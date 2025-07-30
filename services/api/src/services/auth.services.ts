import Role from "../models/Role";
import RoleRepository from "../repositories/role.repository";
import * as AccountRepo from "../repositories/account.repository";
import { getModelByRoleName } from "../utils/roleToModelMap";
import { DefaultLogger } from "../utils/DefaultLogger";
import { ILogger } from "../interfaces/logger.interface";

const roleRepository = new RoleRepository(Role);

// Nếu bạn chưa có logger sẵn thì tạo instance
const logger: ILogger = new DefaultLogger();

/**
 * Tạo user mới theo role, nhận đầy đủ thông tin BaseUser + các field riêng
 */
export const registerUser = async (
  uid: string,
  email: string,
  password: string,
  roleId: string,
  userInfo: any,
  performedBy?: string // ID của admin đang tạo tài khoản, hoặc undefined nếu self-register
) => {
  try {
    const role = await roleRepository.findById(roleId);
    if (!role) throw new Error("❌ Vai trò không tồn tại");

    const UserModel = getModelByRoleName(role.name);

    const user = await UserModel.create({
      ...userInfo,
      roleId: role._id,
    });

    const account = await AccountRepo.createAccount({
      uid,
      email,
      password,
      userId: user._id,
    });

    await logger.log({
      userId: performedBy ?? user._id.toString(), // Nếu là self-register thì ghi nhận chính nó
      action: "REGISTER_USER",
      targetId: user._id.toString(),
      roleSnapshot: role.name,
      metadata: {
        email,
        roleId,
        userInfo,
      },
    });

    return { account, user };
  } catch (error) {
    await logger.log({
      userId: performedBy ?? "System",
      action: "REGISTER_USER_FAILED",
      roleSnapshot: roleId,
      metadata: {
        email,
        roleId,
        userInfo,
        error: (error as Error).message,
      },
    });

    throw error;
  }
};
