import { z } from "zod";
import { Types } from "mongoose";

// Enum cho type
export const TypeEnum = ["percentage", "fixed"] as const;

export const DiscountPolicySchema = z
  .object({
    _id: z
      .string()
      .refine((val) => Types.ObjectId.isValid(val), {
        message: "Định dạng ObjectId không hợp lệ cho _id",
      })
      .optional(),

    name: z
      .string()
      .min(1, { message: "Tên là bắt buộc" })
      .max(100, { message: "Tên không được vượt quá 100 ký tự" }),

    type: z.enum(TypeEnum, {
      message: `Loại phải là một trong: ${TypeEnum.join(", ")}`,
    }),

    value: z.number().positive({ message: "Giá trị phải là một số dương" }),

    applicableTo: z
      .array(
        z.string().refine((val) => Types.ObjectId.isValid(val), {
          message: "Định dạng ObjectId không hợp lệ cho applicableTo user",
        })
      )
      .optional(),
  })
  .superRefine(({ type, value }, ctx) => {
    if (type === "percentage" && (value < 0 || value > 100)) {
      ctx.addIssue({
        code: z.ZodIssueCode.custom,
        path: ["value"],
        message:
          "Giá trị phải nằm trong khoảng từ 0 đến 100 nếu loại là percentage",
      });
    }
  });

export type DiscountPolicy = z.infer<typeof DiscountPolicySchema>;
