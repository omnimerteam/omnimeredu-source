import { z } from "zod";
import { Types } from "mongoose";

// Định nghĩa enum cho status
const StatusEnum = ["Success", "Failed"] as const;

export const VipInvoiceSchema = z.object({
  _id: z
    .string()
    .refine((val) => Types.ObjectId.isValid(val), {
      message: "Invalid ObjectId format for _id",
    })
    .optional(), // MongoDB tự sinh
  schoolId: z
    .string()
    .min(1, { message: "schoolId is required" })
    .refine((val) => Types.ObjectId.isValid(val), {
      message: "Invalid ObjectId format for schoolId",
    }), // Bắt buộc, kiểm tra format ObjectId
  packageId: z
    .string()
    .min(1, { message: "packageId is required" })
    .refine((val) => Types.ObjectId.isValid(val), {
      message: "Invalid ObjectId format for packageId",
    }), // Bắt buộc, kiểm tra format ObjectId
  subscriptionId: z
    .string()
    .min(1, { message: "subscriptionId is required" })
    .refine((val) => Types.ObjectId.isValid(val), {
      message: "Invalid ObjectId format for subscriptionId",
    }), // Bắt buộc, kiểm tra format ObjectId
  paymentMethodId: z
    .string()
    .min(1, { message: "paymentMethodId is required" })
    .refine((val) => Types.ObjectId.isValid(val), {
      message: "Invalid ObjectId format for paymentMethodId",
    }), // Bắt buộc, kiểm tra format ObjectId
  amount: z
    .number()
    .positive({ message: "Amount must be positive" }), // Bắt buộc, số dương
  transactionId: z
    .string()
    .min(1, { message: "transactionId is required" })
    .max(100, { message: "Transaction ID cannot exceed 100 characters" }), // Bắt buộc, validate độ dài
  status: z.enum(StatusEnum, {
    message: `Status must be one of: ${StatusEnum.join(", ")}`,
  }), // Bắt buộc, giới hạn trong enum
  paidAt: z
    .string()
    .datetime({ message: "Invalid date format for paidAt" })
    .refine((val) => new Date(val) <= new Date(), {
      message: "Paid date cannot be in the future",
    }), // Bắt buộc, không ở tương lai
});

export type VipInvoice = z.infer<typeof VipInvoiceSchema>;
export const CreateVipInvoiceSchema = VipInvoiceSchema.omit({ _id: true });
export const UpdateVipInvoiceSchema = VipInvoiceSchema.partial({
  schoolId: true,
  packageId: true,
  subscriptionId: true,
  paymentMethodId: true,
  amount: true,
  transactionId: true,
  status: true,
  paidAt: true,
});