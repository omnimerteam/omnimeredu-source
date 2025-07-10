import Role, { IRole } from "../models/Role";

/**
 * Tìm role theo tên (SuperAdmin, Teacher, ...)
 */
export const findRoleByName = async (name: string): Promise<IRole | null> => {
  return await Role.findOne({ name }).exec();
};
