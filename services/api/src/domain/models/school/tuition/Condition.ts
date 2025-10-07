import { Schema } from "mongoose";

export type Operator =
  | "eq"
  | "neq"
  | "gt"
  | "lt"
  | "gte"
  | "lte"
  | "in"
  | "nin";

export interface ICondition {
  field: string; // path trong context: "student.meta.siblings", "class.baseFee", "attendance.weekendCount"
  operator: Operator;
  value: any;
}

export const ConditionSchema = new Schema<ICondition>(
  {
    field: { type: String, required: true },
    operator: {
      type: String,
      required: true,
      enum: ["eq", "neq", "gt", "lt", "gte", "lte", "in", "nin"],
    },
    value: { type: Schema.Types.Mixed, required: true },
  },
  { _id: false }
);
