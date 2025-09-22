import { z } from "zod";
import { Types } from "mongoose";
import { GenderEnum } from "../../../enum/gender.enum";

export const BaseUserSchema = z.object({
  _id: z
    .string()
    .refine((val) => Types.ObjectId.isValid(val), {
      message: "Định dạng ObjectId không hợp lệ cho _id",
    })
    .optional()
    .nullable(), // MongoDB tự sinh

  fullName: z
    .string()
    .min(2, { message: "Họ tên phải có ít nhất 2 ký tự" })
    .max(100, { message: "Họ tên không vượt quá 100 ký tự" })
    .regex(/^[a-zA-ZÀ-ỹ\s.-]+$/, {
      message:
        "Họ tên chỉ được chứa chữ cái, khoảng trắng, dấu gạch ngang hoặc dấu chấm",
    }),

  roleId: z
    .string()
    .refine((val) => Types.ObjectId.isValid(val), {
      message: "Định dạng ObjectId không hợp lệ cho roleId",
    })
    .optional()
    .nullable(),

  gender: z
    .enum(GenderEnum, {
      message: "Giới tính phải phải là nam, nữ hoặc giới tính khác",
    })
    .optional()
    .nullable(),

  birthday: z
    .string()
    .datetime({ message: "Ngày sinh phải đúng định dạng ISO" })
    .optional()
    .nullable(),

  phone: z
    .string()
    .regex(/^(?:\+84|0)\d{9,10}$/, {
      message: "Số điện thoại không hợp lệ (VD: +84987654321 hoặc 0987654321)",
    })
    .optional()
    .nullable(),

  address: z
    .string()
    .max(500, { message: "Địa chỉ không vượt quá 500 ký tự" })
    .optional()
    .nullable(),

  isVerified: z.boolean().optional().nullable(),

  schoolId: z
    .string()
    .refine((val) => Types.ObjectId.isValid(val), {
      message: "Định dạng ObjectId không hợp lệ cho schoolId",
    })
    .optional()
    .nullable(),
});

export type BaseUser = z.infer<typeof BaseUserSchema>;
