import mongoose, { Schema, Document, Types } from "mongoose";
import { ConditionSchema } from "./Condition";

export type DiscountKind = "percentage" | "fixed";

export interface IDiscountPolicy extends Document {
  code?: string;
  name: string;
  kind: DiscountKind;
  value: number;
  target: "subtotal" | "baseFee" | "specific_fee";
  targetFeeCode?: string;
  maxCap?: number; // max amount discount
  stackable?: boolean; // if false, block other lower-priority discounts
  priority?: number;
  conditions?: any[];
  oncePer?: "month" | "term" | null;
  schoolId: Types.ObjectId;
  active?: boolean;
  effectiveFrom?: Date;
  effectiveTo?: Date | null;
}

const DiscountPolicySchema = new Schema<IDiscountPolicy>(
  {
    code: { type: String, index: true },
    name: { type: String, required: true },
    kind: { type: String, enum: ["percentage", "fixed"], required: true },
    value: { type: Number, required: true, min: 0 },
    target: {
      type: String,
      enum: ["subtotal", "baseFee", "specific_fee"],
      default: "subtotal",
    },
    targetFeeCode: String,
    maxCap: Number,
    stackable: { type: Boolean, default: false },
    priority: { type: Number, default: 0 },
    conditions: [ConditionSchema],
    oncePer: { type: String, enum: ["month", "term", null], default: null },
    schoolId: {
      type: Schema.Types.ObjectId,
      ref: "School",
      required: true,
      index: true,
    },
    active: { type: Boolean, default: true },
    effectiveFrom: { type: Date, default: Date.now },
    effectiveTo: Date,
  },
  { timestamps: true }
);

export default mongoose.model<IDiscountPolicy>(
  "DiscountPolicy",
  DiscountPolicySchema
);
