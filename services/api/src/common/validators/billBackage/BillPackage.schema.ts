import { z } from "zod";
import { Types } from "mongoose";

export const BillPackageSchema = z.object({
  _id: z
    .string()
    .refine((val) => Types.ObjectId.isValid(val), {
      message: "Định dạng ObjectId không hợp lệ cho _id",
    })
    .optional(), // MongoDB tự sinh

  schoolId: z.string().refine((val) => Types.ObjectId.isValid(val), {
    message: "Định dạng ObjectId không hợp lệ cho schoolId",
  }),

  packageId: z.string().refine((val) => Types.ObjectId.isValid(val), {
    message: "Định dạng ObjectId không hợp lệ cho packageId",
  }),

  activatedAt: z
    .string()
    .datetime({ message: "activatedAt phải đúng định dạng ISO datetime" })
    .optional(),

  expiresAt: z
    .string()
    .datetime({ message: "expiresAt phải đúng định dạng ISO datetime" })
    .optional(),

  isActive: z.boolean().optional(),
});

export type BillPackage = z.infer<typeof BillPackageSchema>;
