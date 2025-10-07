import mongoose, { Schema, Document, Types } from "mongoose";

export interface IExtraFeeDetail {
  feeId: Types.ObjectId; // tham chiếu tới ExtraFee
  quantity: number;
  calculatedAmount: number;
}

export interface IDiscountDetail {
  discountId: Types.ObjectId; // tham chiếu tới DiscountPolicy
  appliedAmount: number;
}

export interface ITuition extends Document {
  _id: Types.ObjectId;
  studentId: Types.ObjectId;
  schoolId: Types.ObjectId;
  classId: Types.ObjectId;
  month: string;
  extraFeeDetails?: IExtraFeeDetail[];
  discountDetails?: IDiscountDetail[];
  totalAmount: number;
  attendedDays: number;
  status: "paid" | "pending";
}

// Subschema cho ExtraFeeDetail
const ExtraFeeDetailSchema = new Schema<IExtraFeeDetail>(
  {
    feeId: { type: Schema.Types.ObjectId, ref: "ExtraFee", required: true },
    quantity: { type: Number, default: 1, min: 0 },
    calculatedAmount: { type: Number, required: true },
  },
  { _id: false }
);

// Subschema cho DiscountDetail
const DiscountDetailSchema = new Schema<IDiscountDetail>(
  {
    discountId: {
      type: Schema.Types.ObjectId,
      ref: "DiscountPolicy",
      required: true,
    },
    appliedAmount: { type: Number, required: true },
  },
  { _id: false }
);

const TuitionSchema = new Schema<ITuition>(
  {
    _id: { type: Schema.Types.ObjectId, auto: true },
    studentId: { type: Schema.Types.ObjectId, ref: "BaseUser", required: true },
    schoolId: { type: Schema.Types.ObjectId, ref: "School", required: true },
    classId: { type: Schema.Types.ObjectId, ref: "Class", required: true },
    month: { type: String, required: true },
    extraFeeDetails: [ExtraFeeDetailSchema],
    discountDetails: [DiscountDetailSchema],
    totalAmount: { type: Number, required: true },
    attendedDays: { type: Number, default: 0 },
    status: { type: String, enum: ["paid", "pending"], default: "pending" },
  },
  { timestamps: true }
);

export default mongoose.model<ITuition>("Tuition", TuitionSchema);
