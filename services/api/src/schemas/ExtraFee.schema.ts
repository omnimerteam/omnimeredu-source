import { z } from "zod";
import { Types } from "mongoose";

export const ExtraFeeSchema = z.object({
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
  amount: z
    .number()
    .positive({ message: "Amount must be a positive number" }), // Bắt buộc, số dương
  applicableTo: z
    .array(
      z
        .string()
        .refine((val) => Types.ObjectId.isValid(val), {
          message: "Invalid ObjectId format for applicableTo user",
        })
    )
    .optional(), // Không bắt buộc, mảng ObjectId
});

export type ExtraFee = z.infer<typeof ExtraFeeSchema>;
export const CreateExtraFeeSchema = ExtraFeeSchema.omit({ _id: true });
export const UpdateExtraFeeSchema = ExtraFeeSchema.partial({
  name: true,
  amount: true,
  applicableTo: true,
});