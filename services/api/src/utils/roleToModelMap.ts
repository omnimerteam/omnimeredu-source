import { SuperAdmin } from "../models/SuperAdmin";
import { SchoolAdmin } from "../models/SchoolAdmin";
import { Teacher } from "../models/Teacher";
import { Student } from "../models/Student";
import { BaseUser } from "../models/BaseUser";

// Những role có model riêng (có discriminator)
const specialRoleModels: Record<string, typeof BaseUser> = {
  SuperAdmin,
  SchoolAdmin,
  Teacher,
  Student,
};

/**
 * Hàm lấy model tương ứng với role.
 * Nếu role không có model riêng, trả về BaseUser mặc định.
 */
export const getModelByRoleName = (roleName: string): typeof BaseUser => {
  return specialRoleModels[roleName] || BaseUser;
};
