import { z } from "zod";
import { ClassSchema } from "./Class.schema";

/**
 * ✅ Create Class Validator
 *  - Bỏ qua _id và code (tự generate)
 *  - schoolId bắt buộc truyền từ body
 *  - students là optional
 */
export const createClassBodySchema = ClassSchema.omit({
  _id: true,
  code: true,
  schoolId: true,
}).extend({
  students: ClassSchema.shape.students.optional(),
});

/**
 * ✅ Update Class Validator
 *  - Cho phép update từng field
 *  - students optional
 */
export const updateClassBodySchema = ClassSchema.partial().extend({
  students: ClassSchema.shape.students.optional(),
});

/**
 * ✅ Add/Remove students from class
 *  - students: array ObjectId hợp lệ, không được rỗng
 */
export const modifyStudentsBodySchema = z.object({
  studentIds: z
    .array(
      z
        .string()
        .regex(/^[0-9a-fA-F]{24}$/, "Mỗi studentId phải là ObjectId hợp lệ")
    )
    .min(1, { message: "Danh sách học sinh không được để trống" }),
});

/**
 * ✅ Transfer students to another class
 *  - targetClassId: ObjectId hợp lệ
 *  - students: array ObjectId hợp lệ, không được rỗng
 */
export const transferClassBodySchema = z.object({
  targetClassId: z
    .string()
    .regex(/^[0-9a-fA-F]{24}$/, "targetClassId phải là ObjectId hợp lệ"),
  studentIds: z
    .array(
      z
        .string()
        .regex(/^[0-9a-fA-F]{24}$/, "Mỗi studentId phải là ObjectId hợp lệ")
    )
    .min(1, { message: "Danh sách học sinh không được để trống" }),
});
