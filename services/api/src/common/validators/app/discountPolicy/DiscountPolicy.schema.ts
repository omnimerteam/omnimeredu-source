import { z } from "zod";
import { Types } from "mongoose";
import {
  DiscountKindTuple,
  DiscountTargetTuple,
  DiscountApplicabilityScopeTuple,
  DiscountOncePerTuple,
} from "../../../../common/enum/tuition.enum";
import { ConditionZodSchema } from "../condition/ConditionZodSchema";

/**
 * Schema validate DiscountPolicy (chính sách giảm giá học phí)
 */
export const DiscountPolicyZodSchema = z
  .object({
    _id: z
      .string()
      .refine((v) => Types.ObjectId.isValid(v), {
        message: "_id không hợp lệ",
      })
      .optional(),

    code: z.string().optional(),

    name: z.string().min(1, "Tên là bắt buộc"),
    description: z.string().optional(),

    kind: z.enum(DiscountKindTuple as [string, ...string[]]),
    value: z.number().nonnegative("Giá trị phải >= 0"),

    target: z
      .enum(DiscountTargetTuple as [string, ...string[]])
      .default("Subtotal"),
    targetFeeCode: z.string().optional(),
    maxCap: z.number().optional(),

    stackable: z.boolean().default(false),
    priority: z.number().optional(),
    exclusiveGroup: z.string().optional(),

    oncePer: z
      .enum(DiscountOncePerTuple as [string, ...string[]])
      .default("None"),

    conditions: z.array(ConditionZodSchema).optional(),

    applicabilityScope: z
      .enum(DiscountApplicabilityScopeTuple as [string, ...string[]])
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

    schoolId: z.string().refine((v) => Types.ObjectId.isValid(v), {
      message: "schoolId không hợp lệ",
    }),

    minSubtotal: z.number().optional(),
    maxSubtotal: z.number().optional(),

    active: z.boolean().default(true),
    effectiveFrom: z.coerce.date().optional(),
    effectiveTo: z.coerce.date().nullable().optional(),
  })
  .superRefine(({ kind, value }, ctx) => {
    if (kind === "Percent" && (value < 0 || value > 100)) {
      ctx.addIssue({
        code: z.ZodIssueCode.custom,
        path: ["value"],
        message: "Giá trị phần trăm phải nằm trong khoảng 0–100",
      });
    }
  });

export type DiscountPolicyZod = z.infer<typeof DiscountPolicyZodSchema>;
