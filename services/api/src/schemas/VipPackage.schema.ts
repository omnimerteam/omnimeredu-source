import { z } from "zod";
import { Types } from "mongoose";

// Định nghĩa enum cho name
const NameEnum = ["Basic", "Pro", "Enterprise"] as const;

export const VipPackageSchema = z.object({
  _id: z
    .string()
    .refine((val) => Types.ObjectId.isValid(val), {
      message: "Invalid ObjectId format for _id",
    })
    .optional(), // MongoDB tự sinh
  name: z.enum(NameEnum, {
    message: `Name must be one of: ${NameEnum.join(", ")}`,
  }), // Bắt buộc, giới hạn trong enum
  price: z
    .number()
    .nonnegative({ message: "Price must be non-negative" }), // Bắt buộc, không âm (cho phép 0)
  maxStudents: z
    .number()
    .int({ message: "Max students must be an integer" })
    .nonnegative({ message: "Max students cannot be negative" }), // Bắt buộc, số nguyên không âm
  maxInvoices: z
    .number()
    .int({ message: "Max invoices must be an integer" })
    .nonnegative({ message: "Max invoices cannot be negative" }), // Bắt buộc, số nguyên không âm
  features: z
    .array(
      z.string().max(100, { message: "Each feature cannot exceed 100 characters" })
    )
    .optional(), // Không bắt buộc, mảng chuỗi
});

export type VipPackage = z.infer<typeof VipPackageSchema>;
export const CreateVipPackageSchema = VipPackageSchema.omit({ _id: true });
export const UpdateVipPackageSchema = VipPackageSchema.partial({
  name: true,
  price: true,
  maxStudents: true,
  maxInvoices: true,
  features: true,
});