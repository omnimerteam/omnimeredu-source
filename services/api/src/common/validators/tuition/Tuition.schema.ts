import { z } from "zod";
import { Types } from "mongoose";

// Định nghĩa enum cho status
const StatusEnum = ["paid", "pending"] as const;

export const TuitionSchema = z.object({
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
  month: z
    .string()
    .regex(/^\d{4}-(0[1-9]|1[0-2])$/, {
      message: "Tháng phải có định dạng YYYY-MM (ví dụ: 2025-07)",
    })
    .refine(
      (val) => {
        const [year, month] = val.split("-").map(Number);
        const currentYear = new Date().getFullYear();
        return (
          year >= 2000 && year <= currentYear + 1 && month >= 1 && month <= 12
        );
      },
      {
        message:
          "Tháng phải trong khoảng từ 2000-01 đến " +
          (new Date().getFullYear() + 1) +
          "-12",
      }
    ),
  extraFeeIds: z
    .array(
      z.string().refine((val) => Types.ObjectId.isValid(val), {
        message: "Định dạng ObjectId không hợp lệ cho extraFeeIds",
      })
    )
    .optional(),
  discountId: z
    .string()
    .refine((val) => !val || Types.ObjectId.isValid(val), {
      message: "Định dạng ObjectId không hợp lệ cho discountId",
    })
    .optional(),
  totalAmount: z
    .number()
    .positive({ message: "Tổng số tiền phải là số dương" }),
  attendedDays: z
    .number()
    .int({ message: "Số ngày điểm danh phải là số nguyên" })
    .nonnegative({ message: "Số ngày điểm danh không được âm" })
    .optional(),
  status: z
    .enum(StatusEnum, {
      message: `Trạng thái phải là một trong: ${StatusEnum.join(", ")}`,
    })
    .optional(),
});

export type Tuition = z.infer<typeof TuitionSchema>;
