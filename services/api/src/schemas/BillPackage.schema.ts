import { z } from "zod";
import { Types } from "mongoose";

export const BillPackageSchema = z
  .object({
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
    activatedAt: z
      .string()
      .datetime({ message: "Invalid date format for activatedAt" })
      .optional(), // MongoDB tự set
    expiresAt: z
      .string()
      .datetime({ message: "Invalid date format for expiresAt" })
      .optional(), // Không bắt buộc
    isActive: z.boolean().optional(), // Không bắt buộc, boolean
  })
  .superRefine(({ expiresAt, activatedAt }, ctx) => {
    if (expiresAt && activatedAt) {
      const expiresAtDate = new Date(expiresAt);
      const activatedAtDate = new Date(activatedAt);
      if (expiresAtDate <= activatedAtDate) {
        ctx.addIssue({
          code: z.ZodIssueCode.custom,
          path: ["expiresAt"],
          message: "expiresAt must be after activatedAt",
        });
      }
    }
  });

export type BillPackage = z.infer<typeof BillPackageSchema>;
export const CreateBillPackageSchema = BillPackageSchema.omit({ _id: true, activatedAt: true });
export const UpdateBillPackageSchema = BillPackageSchema.partial({
  schoolId: true,
  packageId: true,
  expiresAt: true,
  isActive: true,
});