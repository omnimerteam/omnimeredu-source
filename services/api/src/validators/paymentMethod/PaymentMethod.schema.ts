import { z } from "zod";
import { Types } from "mongoose";

// Định nghĩa enum cho name
export const NameEnum = ["Momo", "ZaloPay", "Bank", "QRCode"] as const;

export const PaymentMethodSchema = z.object({
  _id: z
    .string()
    .refine((val) => Types.ObjectId.isValid(val), {
      message: "Định dạng ObjectId không hợp lệ cho _id",
    })
    .optional(), // MongoDB tự sinh

  name: z.enum(NameEnum, {
    message: `Tên phương thức thanh toán phải là một trong: ${NameEnum.join(
      ", "
    )}`,
  }),

  description: z
    .string()
    .max(500, { message: "Mô tả không được vượt quá 500 ký tự" })
    .optional(),
});

export type PaymentMethod = z.infer<typeof PaymentMethodSchema>;
