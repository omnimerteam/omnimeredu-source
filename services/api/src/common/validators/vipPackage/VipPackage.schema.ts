import { z } from "zod";
import { Types } from "mongoose";

// Định nghĩa enum cho name
const NameEnum = ["Basic", "Pro", "Enterprise"] as const;

export const VipPackageSchema = z.object({
  _id: z
    .string()
    .refine((val) => Types.ObjectId.isValid(val), {
      message: "Định dạng ObjectId không hợp lệ cho _id",
    })
    .optional(),
  name: z.enum(NameEnum, {
    message: `Tên phải là một trong: ${NameEnum.join(", ")}`,
  }),
  price: z.number().nonnegative({ message: "Giá phải là số không âm" }),
  maxStudents: z
    .number()
    .int({ message: "Số học sinh tối đa phải là số nguyên" })
    .nonnegative({ message: "Số học sinh tối đa không được âm" }),
  maxInvoices: z
    .number()
    .int({ message: "Số hóa đơn tối đa phải là số nguyên" })
    .nonnegative({ message: "Số hóa đơn tối đa không được âm" }),
  features: z
    .array(
      z
        .string()
        .max(100, { message: "Mỗi tính năng không được vượt quá 100 ký tự" })
    )
    .optional(),
});

export type VipPackage = z.infer<typeof VipPackageSchema>;
