import { z } from "zod";
import { Types } from "mongoose";

// Định nghĩa enum cho trạng thái
const StatusEnum = ["Success", "Failed"] as const;

export const VipInvoiceSchema = z.object({
  _id: z
    .string()
    .refine((val) => Types.ObjectId.isValid(val), {
      message: "Định dạng ObjectId không hợp lệ cho _id",
    })
    .optional(),
  schoolId: z
    .string()
    .min(1, { message: "schoolId là bắt buộc" })
    .refine((val) => Types.ObjectId.isValid(val), {
      message: "Định dạng ObjectId không hợp lệ cho schoolId",
    }),
  packageId: z
    .string()
    .min(1, { message: "packageId là bắt buộc" })
    .refine((val) => Types.ObjectId.isValid(val), {
      message: "Định dạng ObjectId không hợp lệ cho packageId",
    }),
  subscriptionId: z
    .string()
    .min(1, { message: "subscriptionId là bắt buộc" })
    .refine((val) => Types.ObjectId.isValid(val), {
      message: "Định dạng ObjectId không hợp lệ cho subscriptionId",
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
    .max(100, { message: "Mã giao dịch không được vượt quá 100 ký tự" }),
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

export type VipInvoice = z.infer<typeof VipInvoiceSchema>;
