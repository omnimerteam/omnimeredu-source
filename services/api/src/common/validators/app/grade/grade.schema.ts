import { z } from "zod";
import {
  EducationGradesEnum,
  EducationGradesTuple,
  EducationSystemLevelsTuple,
} from "../../../enum/educationSystemLevels.enum";
/**
 * 🔹 Schema cơ bản cho Grade
 */
export const GradeSchema = z.object({
  _id: z.string().optional(), // ObjectId dưới dạng string, optional khi tạo mới
  schoolId: z.string({ message: "Trường học là bắt buộc" }), // ObjectId dưới dạng string
  name: z.string({ message: "Tên khối là bắt buộc" }).min(1),
  level: z.enum(EducationSystemLevelsTuple as [string, ...string[]], {
    message: "Cấp học là bắt buộc",
  }),
  gradeGroup: z.enum(EducationGradesTuple as [string, ...string[]], {
    message: "Nhóm khối học là bắt buộc",
  }),
  order: z.number({ message: "Order là bắt buộc" }).int().nonnegative(),
  ageRange: z
    .object({
      min: z.number().int().nonnegative(),
      max: z.number().int().nonnegative(),
    })
    .optional(),
  description: z.string().optional(),
  customFields: z.record(z.string(), z.any()).optional(),
  active: z.boolean().optional().default(true),
});

export type GradeInput = z.infer<typeof GradeSchema>;
