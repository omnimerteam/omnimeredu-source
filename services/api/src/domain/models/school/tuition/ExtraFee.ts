import mongoose, { Schema, Document, Types } from "mongoose";
import { ConditionSchema, ICondition } from "./Condition";
export type FeeCalcType = "fixed" | "per_session" | "per_month" | "formula";
// per_session: multiply by #sessions student attended that match (e.g., Sat classes)
// formula: json-logic or custom expression evaluated with context

export interface IExtraFee extends Document {
  code?: string;
  name: string;
  calcType: FeeCalcType;
  unitAmount: number; // per unit or fixed
  unitName?: string; // "session", "set", ...
  conditions?: ICondition[]; // when to apply
  schoolId: Types.ObjectId;
  oncePer?: "month" | "term" | "year" | null; // for uniform/insurance
  priority?: number;
  active?: boolean;
  effectiveFrom?: Date;
  effectiveTo?: Date | null;
  formula?: any;
}

const ExtraFeeSchema = new Schema<IExtraFee>(
  {
    code: { type: String, index: true },
    name: { type: String, required: true },
    calcType: {
      type: String,
      enum: ["fixed", "per_session", "per_month", "formula"],
      required: true,
    },
    unitAmount: { type: Number, default: 0, min: 0 },
    unitName: String,
    conditions: [ConditionSchema],
    schoolId: {
      type: Schema.Types.ObjectId,
      ref: "School",
      required: true,
      index: true,
    },
    oncePer: {
      type: String,
      enum: ["month", "term", "year", null],
      default: null,
    },
    priority: { type: Number, default: 0 },
    active: { type: Boolean, default: true },
    effectiveFrom: { type: Date, default: Date.now },
    effectiveTo: { type: Date, default: null },
    formula: { type: Schema.Types.Mixed },
  },
  { timestamps: true }
);

export default mongoose.model<IExtraFee>("ExtraFee", ExtraFeeSchema);
