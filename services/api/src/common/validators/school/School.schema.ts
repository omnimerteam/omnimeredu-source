import { z } from "zod";
import { Types } from "mongoose";
import { EducationSystemLevelsTuple } from "../../enum/educationSystemLevels.enum";

export const SchoolSchema = z.object({
  _id: z
    .string()
    .refine((val) => Types.ObjectId.isValid(val), {
      message: "Định dạng ObjectId không hợp lệ cho _id",
    })
    .optional(),

  name: z
    .string()
    .min(1, { message: "Tên trường là bắt buộc" })
    .max(200, { message: "Tên trường không được vượt quá 200 ký tự" }),

  code: z.string().optional(),

  address: z
    .string()
    .min(10, { message: "Địa chỉ phải có ít nhất 10 ký tự" })
    .max(500, { message: "Địa chỉ không được vượt quá 500 ký tự" }),

  phone: z
    .string()
    .regex(/^\+?[0-9]{8,15}$/, {
      message: "Số điện thoại không hợp lệ",
    })
    .optional(),

  description: z
    .string()
    .max(1000, { message: "Mô tả không được vượt quá 1000 ký tự" })
    .optional(),

  level: z.enum(EducationSystemLevelsTuple, {
    message: `Cấp trường phải là một trong: ${EducationSystemLevelsTuple.join(
      ", "
    )}`,
  }),

  adminId: z
    .string()
    .refine((val) => !val || Types.ObjectId.isValid(val), {
      message: "Định dạng ObjectId không hợp lệ cho adminId",
    })
    .optional(),

  logoUrl: z
    .string()
    .url({ message: "Đường dẫn logo không hợp lệ" })
    .optional(),

  studentCount: z.number().default(0),

  customTheme: z.record(z.string(), z.any()).optional(),
});

export type School = z.infer<typeof SchoolSchema>;
