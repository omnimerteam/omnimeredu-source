import { z } from "zod";
import { Types } from "mongoose";
import {
  FeeCalcTypeTuple,
  ExtraFeeApplicabilityScopeTuple,
  ExtraFeeOncePerTuple,
} from "../../../../common/enum/tuition.enum";
import { ConditionZodSchema } from "../condition/ConditionZodSchema";

/**
 * Schema validate ExtraFee (phụ phí)
 */
export const ExtraFeeZodSchema = z.object({
  _id: z
    .string()
    .refine((val) => Types.ObjectId.isValid(val), {
      message: "_id không hợp lệ",
    })
    .optional(),

  code: z.string().optional(),

  name: z.string().min(1, "Tên là bắt buộc"),

  description: z.string().optional(),

  calcType: z.enum(FeeCalcTypeTuple as [string, ...string[]], {
    message: `Loại tính toán không hợp lệ. (${FeeCalcTypeTuple.join(", ")})`,
  }),

  unitAmount: z.number().nonnegative("Giá trị phải >= 0"),

  conditions: z.array(ConditionZodSchema).optional(),

  schoolId: z.string().refine((val) => Types.ObjectId.isValid(val), {
    message: "schoolId không hợp lệ",
  }),

  applicableScope: z
    .enum(ExtraFeeApplicabilityScopeTuple as [string, ...string[]])
    .default("All"),

  applicableClassIds: z
    .array(
      z.string().refine((v) => Types.ObjectId.isValid(v), {
        message: "ObjectId lớp không hợp lệ",
      })
    )
    .optional(),

  applicableGradeIds: z
    .array(
      z.string().refine((v) => Types.ObjectId.isValid(v), {
        message: "ObjectId khối không hợp lệ",
      })
    )
    .optional(),

  applicableStudentIds: z
    .array(
      z.string().refine((v) => Types.ObjectId.isValid(v), {
        message: "ObjectId học sinh không hợp lệ",
      })
    )
    .optional(),

  oncePer: z
    .enum(ExtraFeeOncePerTuple as [string, ...string[]])
    .default("None"),

  priority: z.number().optional(),
  active: z.boolean().default(true),

  effectiveFrom: z.coerce.date().optional(),
  effectiveTo: z.coerce.date().nullable().optional(),

  isTaxable: z.boolean().default(false),
  taxRate: z.number().min(0).optional(),
});

export type ExtraFeeZod = z.infer<typeof ExtraFeeZodSchema>;
