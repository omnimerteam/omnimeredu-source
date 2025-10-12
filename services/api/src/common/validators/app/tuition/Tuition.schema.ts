import { z } from "zod";
import { Types } from "mongoose";
import {
  TuitionStatusTuple,
  DiscountKindTuple,
  CurrencyTuple,
} from "../../../../common/enum/tuition.enum";

/* ---------- Helper Validators ---------- */
const objectId = z.string().refine((val) => Types.ObjectId.isValid(val), {
  message: "Giá trị không hợp lệ, phải là ObjectId hợp lệ",
});

/* ---------- Subschema: ExtraFeeDetail ---------- */
export const ExtraFeeDetailZod = z.object({
  feeId: objectId,
  feeCode: z.string().optional(),
  feeName: z.string().optional(),
  unitAmountSnapshot: z.number().nonnegative().optional(),
  quantity: z.number().nonnegative().default(1),
  calculatedAmount: z.number().nonnegative(),
});

/* ---------- Subschema: DiscountDetail ---------- */
export const DiscountDetailZod = z.object({
  discountId: objectId,
  discountCode: z.string().optional(),
  discountName: z.string().optional(),
  kind: z.enum([...DiscountKindTuple] as [string, ...string[]]).optional(),
  valueSnapshot: z.number().nonnegative().optional(),
  appliedAmount: z.number().nonnegative(),
});

/* ---------- Main Schema: Tuition ---------- */
export const TuitionZodSchema = z.object({
  _id: objectId.optional(),

  studentId: objectId,
  schoolId: objectId,
  classId: objectId,

  // Dữ liệu kỳ học
  month: z.string().optional(),
  periodStart: z.coerce.date().optional(),
  periodEnd: z.coerce.date().optional(),

  // Học phí & chi tiết
  baseFeeSnapshot: z.number().nonnegative(),
  extraFeeDetails: z.array(ExtraFeeDetailZod).optional(),
  discountDetails: z.array(DiscountDetailZod).optional(),
  appliedRules: z.any().optional(),
  calculationLog: z.record(z.string(), z.any()).optional(),

  // Tổng tiền & ngày điểm danh
  totalAmount: z.number().nonnegative(),
  attendedDays: z.number().int().nonnegative().default(0),

  // Loại tiền tệ
  currency: z.enum([...CurrencyTuple] as [string, ...string[]]).default("VND"),

  // Trạng thái
  status: z
    .enum([...TuitionStatusTuple] as [string, ...string[]])
    .default("draft"),

  // Metadata
  createdBy: objectId.optional(),
  confirmedBy: objectId.optional(),
  confirmedAt: z.coerce.date().optional(),
  paidAt: z.coerce.date().optional(),
  invoiceId: z.string().optional(),
  dueDate: z.coerce.date().optional(),
  meta: z.record(z.string(), z.any()).optional(),
});

/* ---------- TypeScript Type ---------- */
export type TuitionZodType = z.infer<typeof TuitionZodSchema>;
