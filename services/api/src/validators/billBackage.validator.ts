import { z } from "zod";
import { BillPackageSchema } from "../schemas/BillPackage.schema";

export const createBillPackageBodySchema = BillPackageSchema.omit({
  _id: true,
  activatedAt: true,
})
  .extend({
    schoolId: z
      .string()
      .min(1, { message: "schoolId là bắt buộc" })
      .refine((val) => /^[0-9a-fA-F]{24}$/.test(val), {
        message: "Định dạng ObjectId không hợp lệ cho schoolId",
      }),

    packageId: z
      .string()
      .min(1, { message: "packageId là bắt buộc" })
      .refine((val) => /^[0-9a-fA-F]{24}$/.test(val), {
        message: "Định dạng ObjectId không hợp lệ cho packageId",
      }),

    expiresAt: z
      .string()
      .datetime({ message: "expiresAt phải đúng định dạng ISO datetime" })
      .optional(),
  })
  .superRefine(({ expiresAt }, ctx) => {
    if (expiresAt) {
      const now = new Date();
      const expiresAtDate = new Date(expiresAt);
      if (expiresAtDate <= now) {
        ctx.addIssue({
          code: z.ZodIssueCode.custom,
          path: ["expiresAt"],
          message: "Ngày hết hạn phải sau thời điểm hiện tại",
        });
      }
    }
  });

export const updateBillPackageBodySchema = BillPackageSchema.partial({
  schoolId: true,
  packageId: true,
  expiresAt: true,
  isActive: true,
})
  .extend({
    schoolId: z
      .string()
      .refine((val) => /^[0-9a-fA-F]{24}$/.test(val), {
        message: "Định dạng ObjectId không hợp lệ cho schoolId",
      })
      .optional(),

    packageId: z
      .string()
      .refine((val) => /^[0-9a-fA-F]{24}$/.test(val), {
        message: "Định dạng ObjectId không hợp lệ cho packageId",
      })
      .optional(),

    expiresAt: z
      .string()
      .datetime({ message: "expiresAt phải đúng định dạng ISO datetime" })
      .optional(),
  })
  .superRefine(({ expiresAt, activatedAt }, ctx) => {
    if (expiresAt && activatedAt) {
      const expiresAtDate = new Date(expiresAt);
      const activatedAtDate = new Date(activatedAt);
      if (expiresAtDate <= activatedAtDate) {
        ctx.addIssue({
          code: z.ZodIssueCode.custom,
          path: ["expiresAt"],
          message: "Ngày hết hạn phải sau ngày kích hoạt",
        });
      }
    }
  });
