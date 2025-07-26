import { z } from "zod";
import { Types } from "mongoose";

// Định nghĩa enum cho name
const NameEnum = ["Momo", "ZaloPay", "Bank", "QRCode"] as const;

export const PaymentMethodSchema = z.object({
  _id: z
    .string()
    .refine((val) => Types.ObjectId.isValid(val), {
      message: "Invalid ObjectId format for _id",
    })
    .optional(), // MongoDB tự sinh
  name: z.enum(NameEnum, {
    message: `Name must be one of: ${NameEnum.join(", ")}`,
  }), // Bắt buộc, giới hạn trong enum
  description: z
    .string()
    .max(500, { message: "Description cannot exceed 500 characters" })
    .optional(), // Không bắt buộc, validate độ dài
});

export type PaymentMethod = z.infer<typeof PaymentMethodSchema>;
export const CreatePaymentMethodSchema = PaymentMethodSchema.omit({ _id: true });
export const UpdatePaymentMethodSchema = PaymentMethodSchema.partial({
  name: true,
  description: true,
});