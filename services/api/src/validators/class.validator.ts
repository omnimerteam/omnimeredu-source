import { z } from "zod";
import { ClassSchema } from "../schemas/Class.schema";

// ✅ Create Class Validator
export const createClassBodySchema = ClassSchema.omit({ _id: true }).extend({
  students: ClassSchema.shape.students.unwrap().optional(), // Có thể thêm rule bắt buộc khác nếu cần
});

// ✅ Update Class Validator
export const updateClassBodySchema = ClassSchema.partial({
  name: true,
  code: true,
  schoolId: true,
  teacherId: true,
  students: true,
  baseFee: true,
}).extend({
  students: ClassSchema.shape.students.unwrap().optional(),
});

// Custom validate
/**
 * Add/Remove students from class
 */
export const modifyStudentsBodySchema = z.object({
  students: z
    .array(
      z.string().refine((val) => /^[0-9a-fA-F]{24}$/.test(val), {
        message: "Mỗi studentId phải là ObjectId hợp lệ",
      })
    )
    .nonempty({ message: "Danh sách học sinh không được để trống" }),
});

/**
 * Transfer students to another class
 */
export const transferClassBodySchema = z.object({
  targetClassId: z.string().refine((val) => /^[0-9a-fA-F]{24}$/.test(val), {
    message: "targetClassId phải là ObjectId hợp lệ",
  }),
  students: z
    .array(
      z.string().refine((val) => /^[0-9a-fA-F]{24}$/.test(val), {
        message: "Mỗi studentId phải là ObjectId hợp lệ",
      })
    )
    .nonempty({ message: "Danh sách học sinh không được để trống" }),
});
