import BaseUser from "../models/BaseUser";
import SchoolAdmin from "../models/SchoolAdmin";
import Student from "../models/Student";
import SuperAdmin from "../models/SuperAdmin";
import Teacher from "../models/Teacher";
import { Model } from "mongoose";

// Những role có model riêng (có discriminator)
const specialRoleModels: Record<string, Model<any>> = {
  SuperAdmin,
  SchoolAdmin,
  Teacher,
  Student,
};

/**
 * Hàm lấy model tương ứng với role.
 * Nếu role không có model riêng, trả về BaseUser mặc định.
 */
export const getModelByRoleName = (roleName: string): Model<any> => {
  return specialRoleModels[roleName] || BaseUser;
};
