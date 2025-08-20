import { z } from "zod";
import { Types } from "mongoose";
import { BaseUserSchema } from "../baseUser/BaseUser.schema";

// Enum cấp học đúng như model mongoose
const EducationLevelEnum = [
  "Preschool",
  "Primary",
  "Secondary",
  "HighSchool",
] as const;

// Schema cho Student, kế thừa BaseUserSchema
export const StudentSchema = BaseUserSchema.extend({
  classId: z
    .string()
    .optional()
    .refine((val) => !val || Types.ObjectId.isValid(val), {
      message: "Định dạng ObjectId không hợp lệ cho classId",
    }),

  guardianName: z
    .string()
    .max(100, { message: "Tên phụ huynh không được vượt quá 100 ký tự" })
    .optional(),

  guardianPhone: z
    .string()
    .regex(/^\+?[0-9]{8,15}$/, {
      message: "Số điện thoại phụ huynh không hợp lệ",
    })
    .optional(),

  educationLevel: z.enum(EducationLevelEnum, {
    message: `Cấp học phải thuộc một trong các giá trị: ${EducationLevelEnum.join(
      ", "
    )}`,
  }),

  grade: z
    .string()
    .max(20, { message: "Khối/lớp không được vượt quá 20 ký tự" })
    .optional(),
});

export type Student = z.infer<typeof StudentSchema>;
