import { z } from "zod";
import { Types } from "mongoose";

// Định nghĩa enum cho status
const StatusEnum = ["paid", "pending"] as const;

export const TuitionSchema = z.object({
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
  month: z
    .string()
    .regex(/^\d{4}-(0[1-9]|1[0-2])$/, {
      message: "Month must be in format YYYY-MM (e.g., 2025-07)",
    })
    .refine((val) => {
      const [year, month] = val.split("-").map(Number);
      const currentYear = new Date().getFullYear();
      return year >= 2000 && year <= currentYear + 1 && month >= 1 && month <= 12;
    }, {
      message: "Month must be between 2000-01 and " + (new Date().getFullYear() + 1) + "-12",
    }), // Bắt buộc, validate format và range
  extraFeeIds: z
    .array(
      z.string().refine((val) => Types.ObjectId.isValid(val), {
        message: "Invalid ObjectId format for extraFeeIds",
      })
    )
    .optional(), // Không bắt buộc, mảng ObjectId
  discountId: z
    .string()
    .refine((val) => !val || Types.ObjectId.isValid(val), {
      message: "Invalid ObjectId format for discountId",
    })
    .optional(), // Không bắt buộc, kiểm tra format nếu có
  totalAmount: z
    .number()
    .positive({ message: "Total amount must be positive" }), // Bắt buộc, số dương
  attendedDays: z
    .number()
    .int({ message: "Attended days must be an integer" })
    .nonnegative({ message: "Attended days cannot be negative" })
    .optional(), // Không bắt buộc, số nguyên không âm
  status: z.enum(StatusEnum, {
    message: `Status must be one of: ${StatusEnum.join(", ")}`,
  }).optional(), // Không bắt buộc, giới hạn trong enum
});

export type Tuition = z.infer<typeof TuitionSchema>;
export const CreateTuitionSchema = TuitionSchema.omit({ _id: true });
export const UpdateTuitionSchema = TuitionSchema.partial({
  studentId: true,
  month: true,
  extraFeeIds: true,
  discountId: true,
  totalAmount: true,
  attendedDays: true,
  status: true,
});