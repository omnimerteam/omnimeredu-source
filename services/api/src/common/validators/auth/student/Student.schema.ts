import { z } from "zod";
import { Types } from "mongoose";
import { BaseUserSchema } from "../baseUser/BaseUser.schema";
import {
  EducationGradesTuple,
  EducationSystemLevelsTuple,
} from "../../../enum/educationSystemLevels.enum";

// Schema cho Student, kế thừa BaseUserSchema
export const StudentSchema = BaseUserSchema.extend({
  classId: z
    .string()
    .optional()
    .nullable()
    .refine((val) => !val || Types.ObjectId.isValid(val), {
      message: "Định dạng ObjectId không hợp lệ cho classId",
    }),

  guardianName: z
    .string()
    .max(100, { message: "Tên phụ huynh không được vượt quá 100 ký tự" })
    .optional()
    .nullable(),

  guardianPhone: z
    .string()
    .regex(/^\+?[0-9]{8,15}$/, {
      message: "Số điện thoại phụ huynh không hợp lệ",
    })
    .optional()
    .nullable(),

  educationLevel: z.enum(EducationSystemLevelsTuple, {
    message: `Cấp học phải thuộc một trong các giá trị:
    `,
  }),

  gradeGroup: z.enum(EducationGradesTuple, {
    message: "Dữ liệu không hợp lệ",
  }),
});

export type Student = z.infer<typeof StudentSchema>;
