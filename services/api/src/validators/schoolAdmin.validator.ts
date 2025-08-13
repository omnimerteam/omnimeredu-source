import { z } from "zod";
import { SchoolAdminSchema } from "../schemas/SchoolAdmin.schema";

// Validator khi tạo mới SchoolAdmin (bắt buộc các field cần thiết)
export const createSchoolAdminBodySchema = SchoolAdminSchema.omit({
  _id: true,
});

// Validator khi cập nhật SchoolAdmin (các trường đều optional)
export const updateSchoolAdminBodySchema = SchoolAdminSchema.partial({
  fullName: true,
  roleId: true,
  gender: true,
  birthday: true,
  phone: true,
  address: true,
  isVerified: true,
  position: true,
});
