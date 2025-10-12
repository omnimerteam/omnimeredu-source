import { Schema } from "mongoose";
import {
  TuitionConditionOperatorEnum,
  TuitionConditionOperatorTuple,
  TuitionConditionValueTypeTuple,
  TuitionConditionValueTypeEnum,
} from "../../../../common/enum/tuition.enum";

/**
 * ICondition đại diện cho điều kiện áp dụng ExtraFee hoặc DiscountPolicy.
 * Ví dụ:
 *  - { field: "student.meta.siblings", operator: "gte", value: 1 }
 *  - { field: "attendance.weekendCount", operator: "gt", value: 0 }
 */
export interface ICondition {
  field: string; // path trong context: "student.meta.siblings", "class.baseFee", "attendance.weekendCount"
  operator: TuitionConditionOperatorEnum;
  value: any;
  negate?: boolean;
  valueType?: TuitionConditionValueTypeEnum;
}

/**
 * Mongoose Schema cho điều kiện, dùng trong ExtraFee và DiscountPolicy.
 */
export const ConditionSchema = new Schema<ICondition>(
  {
    field: { type: String, required: true },
    operator: {
      type: String,
      required: true,
      enum: TuitionConditionOperatorTuple,
    },
    value: { type: Schema.Types.Mixed, required: true },
    negate: { type: Boolean, default: false },
    valueType: { type: String, enum: TuitionConditionValueTypeTuple },
  },
  { _id: false }
);
