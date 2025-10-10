import { z } from "zod";
import { Types } from "mongoose";

export const ExtraFeeSchema = z.object({
  _id: z
    .string()
    .refine((val) => Types.ObjectId.isValid(val), {
      message: "Định dạng ObjectId không hợp lệ cho _id",
    })
    .optional(), // MongoDB tự sinh

  name: z
    .string()
    .min(1, { message: "Tên là bắt buộc" })
    .max(100, { message: "Tên không được vượt quá 100 ký tự" }),

  amount: z.number().positive({ message: "Số tiền phải là số dương" }),

  applicableTo: z
    .array(
      z.string().refine((val) => Types.ObjectId.isValid(val), {
        message: "Định dạng ObjectId không hợp lệ cho applicableTo",
      })
    )
    .optional(),
});

export type ExtraFee = z.infer<typeof ExtraFeeSchema>;
