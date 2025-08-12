import { z } from "zod";
import { Types } from "mongoose";

// Định nghĩa enum cho name
export const NameEnum = [
  "SuperAdmin",
  "SchoolAdmin",
  "Teacher",
  "Student",
  "CanteenStaff",
  "Nurse",
  "Security",
] as const;

export const RoleSchema = z.object({
  _id: z
    .string()
    .refine((val) => Types.ObjectId.isValid(val), {
      message: "Định dạng ObjectId không hợp lệ cho _id",
    })
    .optional(), // MongoDB tự sinh

  name: z.enum(NameEnum, {
    message: `Tên vai trò phải là một trong: ${NameEnum.join(", ")}`,
  }),

  description: z
    .string()
    .max(500, { message: "Mô tả không được vượt quá 500 ký tự" })
    .optional(),

  permissions: z
    .array(
      z
        .string()
        .max(100, { message: "Mỗi quyền không được vượt quá 100 ký tự" })
    )
    .optional(),
});

export type Role = z.infer<typeof RoleSchema>;
