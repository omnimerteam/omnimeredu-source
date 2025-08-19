import mongoose, { Schema, Document, Types } from "mongoose";

export interface ICondition {
  field: string; // Trường để kiểm tra (vd: "age", "pickupService", "mealPlan")
  operator: string; // eq, gte, lte, in, ...
  value: any; // Giá trị so sánh
}

export interface IExtraFee extends Document {
  _id: Types.ObjectId;
  name: string;
  amount: number;
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
    value: { type: Schema.Types.Mixed, required: true },
  },
  { _id: false }
);

const ExtraFeeSchema = new Schema<IExtraFee>(
  {
    _id: { type: Schema.Types.ObjectId, auto: true },
    name: { type: String, required: true, trim: true },
    amount: { type: Number, required: true, min: 0 },
    note: { type: String, trim: true },
    conditions: [ConditionSchema],
  },
  { timestamps: true }
);

export default mongoose.model<IExtraFee>("ExtraFee", ExtraFeeSchema);
