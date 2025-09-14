import { z } from "zod";
import { StudentSchema } from "./Student.schema";

// Validator khi tạo mới Student (bỏ _id)
export const createStudentBodySchema = StudentSchema.omit({
  _id: true,
  schoolId: true,
  classId: true,
});

// Validator khi cập nhật Student (các trường đều optional)
export const updateStudentBodySchema = StudentSchema.partial({
  fullName: true,
  roleId: true,
  gender: true,
  birthday: true,
  phone: true,
  address: true,
  isVerified: true,
  classId: true,
  guardianName: true,
  guardianPhone: true,
  educationLevel: true,
  grade: true,
});
