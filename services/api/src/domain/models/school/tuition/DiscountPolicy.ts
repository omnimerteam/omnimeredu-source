import mongoose, { Schema, Document, Types } from "mongoose";

export interface ICondition {
  field: string; // Trường kiểm tra, ví dụ: "siblings", "enrollDate", "baseFee"
  operator: string; // Toán tử: "eq", "gte", "lte", "in"...
  value: any; // Giá trị để so sánh
}

export interface IDiscountPolicy extends Document {
  _id: Types.ObjectId;
  name: string;
  type: "percentage" | "fixed";
  value: number;
  note?: string;
  conditions?: ICondition[];
}

const ConditionSchema = new Schema<ICondition>(
  {
    field: { type: String, required: true },
    operator: {
      type: String,
      required: true,
      enum: ["eq", "neq", "gte", "lte", "gt", "lt", "in", "nin"],
    },
    value: { type: Schema.Types.Mixed, required: true }, // Cho phép nhiều kiểu dữ liệu
  },
  { _id: false }
);

const DiscountPolicySchema = new Schema<IDiscountPolicy>(
  {
    _id: { type: Schema.Types.ObjectId, auto: true },
    name: { type: String, required: true, trim: true },
    type: { type: String, enum: ["percentage", "fixed"], required: true },
    value: { type: Number, required: true, min: 0 },
    note: { type: String, trim: true },
    conditions: [ConditionSchema],
  },
  { timestamps: true }
);

export default mongoose.model<IDiscountPolicy>(
  "DiscountPolicy",
  DiscountPolicySchema
);
