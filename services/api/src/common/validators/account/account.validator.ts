import { z } from "zod";
import { AccountSchema } from "./Account.schema";
import { Types } from "mongoose";

const strongPasswordRegex =
  /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$/;

export const createAccountBodySchema = AccountSchema.omit({
  _id: true,
  token: true,
  uid: true,
  userId: true,
}).extend({
  email: z
    .string()
    .min(1, { message: "Email là bắt buộc" })
    .email({ message: "Email không hợp lệ" }),

  password: z
    .string()
    .min(1, { message: "Mật khẩu là bắt buộc" })
    .min(8, { message: "Mật khẩu phải có ít nhất 8 ký tự" })
    .regex(strongPasswordRegex, {
      message:
        "Mật khẩu phải chứa ít nhất một chữ hoa, một chữ thường, một số và một ký tự đặc biệt",
    }),
  schoolId: z
    .string()
    .refine((val) => Types.ObjectId.isValid(val), {
      message: "Định dạng ObjectId không hợp lệ cho schoolId",
    })
    .optional(),
  classId: z
    .string()
    .refine((val) => Types.ObjectId.isValid(val), {
      message: "Định dạng ObjectId không hợp lệ cho classId",
    })
    .optional(),
  baseUserInfo: z.record(z.string(), z.any()),
  specificInfo: z.record(z.string(), z.any()).optional(),
  schoolData: z.record(z.string(), z.any()).optional(),
});

export const changePasswordSchema = z.object({
  oldPassword: z.string().min(1, { message: "Mật khẩu cũ là bắt buộc" }),
  newPassword: z
    .string()
    .min(1, { message: "Mật khẩu mới là bắt buộc" })
    .min(8, { message: "Mật khẩu mới phải có ít nhất 8 ký tự" })
    .regex(strongPasswordRegex, {
      message:
        "Mật khẩu phải chứa ít nhất một chữ hoa, một chữ thường, một số và một ký tự đặc biệt",
    }),
});

export const updatePasswordSchema = z.object({
  newPassword: z.string().min(1, { message: "Mật khẩu mới là bắt buộc" }),
});
