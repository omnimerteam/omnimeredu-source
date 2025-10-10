import { z } from "zod";
import { Types } from "mongoose";

// Định nghĩa enum cho trạng thái
const StatusEnum = ["Success", "Failed"] as const;

export const TuitionInvoiceSchema = z.object({
  _id: z
    .string()
    .refine((val) => Types.ObjectId.isValid(val), {
      message: "Định dạng ObjectId không hợp lệ cho _id",
    })
    .optional(),
  studentId: z
    .string()
    .min(1, { message: "studentId là bắt buộc" })
    .refine((val) => Types.ObjectId.isValid(val), {
      message: "Định dạng ObjectId không hợp lệ cho studentId",
    }),
  tuitionId: z
    .string()
    .min(1, { message: "tuitionId là bắt buộc" })
    .refine((val) => Types.ObjectId.isValid(val), {
      message: "Định dạng ObjectId không hợp lệ cho tuitionId",
    }),
  paymentMethodId: z
    .string()
    .min(1, { message: "paymentMethodId là bắt buộc" })
    .refine((val) => Types.ObjectId.isValid(val), {
      message: "Định dạng ObjectId không hợp lệ cho paymentMethodId",
    }),
  amount: z.number().positive({ message: "Số tiền phải là số dương" }),
  transactionId: z
    .string()
    .min(1, { message: "transactionId là bắt buộc" })
    .max(100, { message: "Transaction ID không được vượt quá 100 ký tự" }),
  status: z.enum(StatusEnum, {
    message: `Trạng thái phải là một trong: ${StatusEnum.join(", ")}`,
  }),
  paidAt: z
    .string()
    .datetime({ message: "Định dạng ngày thanh toán không hợp lệ" })
    .refine((val) => new Date(val) <= new Date(), {
      message: "Ngày thanh toán không được ở tương lai",
    }),
});

export type TuitionInvoice = z.infer<typeof TuitionInvoiceSchema>;
