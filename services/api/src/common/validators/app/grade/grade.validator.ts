import { z } from "zod";
import { GradeSchema } from "./grade.schema";

// 🔹 Validator cho create grade
// Lấy tất cả field bắt buộc từ GradeSchema
export const createGradeBodySchema = GradeSchema.pick({
  name: true,
  level: true,
  gradeGroup: true,
  order: true,
  ageRange: true,
  description: true,
  customFields: true,
  active: true,
});

// 🔹 Validator cho update grade
// Tất cả field đều optional để update riêng lẻ
// Tất cả field optional nhưng bỏ schoolId
export const updateGradeBodySchema = GradeSchema.omit({ schoolId: true }) // không cho update schoolId
  .partial(); // tất cả field còn lại optional

// 🔹 Validator cho chỉ update trạng thái active
export const updateActiveBodySchema = z.object({
  active: z.boolean({ message: "Trường trạng thái là bắt buộc" }),
});
