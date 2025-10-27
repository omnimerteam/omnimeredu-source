import { z } from "zod";
import { Types } from "mongoose";
import {
  TuitionConditionOperatorTuple,
  TuitionConditionValueTypeTuple,
} from "../../../../common/enum/tuition.enum";

/**
 * Zod schema cho Condition (điều kiện áp dụng)
 */
export const ConditionZodSchema = z.object({
  field: z.string().min(1, "Tên field là bắt buộc"),
  operator: z.enum(TuitionConditionOperatorTuple as [string, ...string[]], {
    message: `Operator không hợp lệ. Phải là một trong: ${TuitionConditionOperatorTuple.join(
      ", "
    )}`,
  }),
  value: z.any(),
  negate: z.boolean().optional(),
  valueType: z
    .enum(TuitionConditionValueTypeTuple as [string, ...string[]])
    .optional(),
});

export type ConditionZod = z.infer<typeof ConditionZodSchema>;
