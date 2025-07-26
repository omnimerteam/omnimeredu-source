import { z } from "zod";
import { Types } from "mongoose";

// Định nghĩa enum cho type
const TypeEnum = ["percentage", "fixed"] as const;

export const DiscountPolicySchema = z
  .object({
    _id: z
      .string()
      .refine((val) => Types.ObjectId.isValid(val), {
        message: "Invalid ObjectId format for _id",
      })
      .optional(), // MongoDB tự sinh
    name: z
      .string()
      .min(1, { message: "Name is required" })
      .max(100, { message: "Name cannot exceed 100 characters" }), // Bắt buộc, validate độ dài
    type: z.enum(TypeEnum), // Bắt buộc, giới hạn trong enum
    value: z
      .number()
      .positive({ message: "Value must be a positive number" }), // Bắt buộc, số dương
    applicableTo: z
      .array(
        z
          .string()
          .refine((val) => Types.ObjectId.isValid(val), {
            message: "Invalid ObjectId format for applicableTo user",
          })
      )
      .optional(), // Không bắt buộc, mảng ObjectId
  })
  .superRefine(({ type, value }, ctx) => {
    if (type === "percentage" && (value < 0 || value > 100)) {
      ctx.addIssue({
        code: z.ZodIssueCode.custom,
        path: ["value"],
        message: "Value must be between 0 and 100 for percentage type",
      });
    }
  });

export type DiscountPolicy = z.infer<typeof DiscountPolicySchema>;
export const CreateDiscountPolicySchema = DiscountPolicySchema.omit({ _id: true });
export const UpdateDiscountPolicySchema = DiscountPolicySchema.partial({
  name: true,
  type: true,
  value: true,
  applicableTo: true,
});