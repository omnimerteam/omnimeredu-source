import { z } from "zod";
import { Types } from "mongoose";

// Định nghĩa enum cho status
const StatusEnum = ["Success", "Failed"] as const;

export const TuitionInvoiceSchema = z.object({
  _id: z
    .string()
    .refine((val) => Types.ObjectId.isValid(val), {
      message: "Invalid ObjectId format for _id",
    })
    .optional(), // MongoDB tự sinh
  studentId: z
    .string()
    .min(1, { message: "studentId is required" })
    .refine((val) => Types.ObjectId.isValid(val), {
      message: "Invalid ObjectId format for studentId",
    }), // Bắt buộc, kiểm tra format ObjectId
  tuitionId: z
    .string()
    .min(1, { message: "tuitionId is required" })
    .refine((val) => Types.ObjectId.isValid(val), {
      message: "Invalid ObjectId format for tuitionId",
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

export type TuitionInvoice = z.infer<typeof TuitionInvoiceSchema>;
export const CreateTuitionInvoiceSchema = TuitionInvoiceSchema.omit({ _id: true });
export const UpdateTuitionInvoiceSchema = TuitionInvoiceSchema.partial({
  studentId: true,
  tuitionId: true,
  paymentMethodId: true,
  amount: true,
  transactionId: true,
  status: true,
  paidAt: true,
});