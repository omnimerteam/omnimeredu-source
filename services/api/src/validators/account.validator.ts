import { z } from "zod";
import { AccountSchema } from "../schemas/Account.schema";

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
  baseUserInfo: z.record(z.string(), z.any()),
  specificInfo: z.record(z.string(), z.any()).optional(),
});

export const updateAccountBodySchema = AccountSchema.partial({
  email: true,
  password: true,
  uid: true,
  token: true,
  userId: true,
}).extend({
  email: z.string().email({ message: "Email không hợp lệ" }).optional(),

  password: z
    .string()
    .min(8, { message: "Mật khẩu phải có ít nhất 8 ký tự" })
    .regex(strongPasswordRegex, {
      message:
        "Mật khẩu phải chứa ít nhất một chữ hoa, một chữ thường, một số và một ký tự đặc biệt",
    })
    .optional(),
});
