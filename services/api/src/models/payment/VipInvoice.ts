import mongoose, { Schema, Document, Types } from "mongoose";

export interface IVipInvoice extends Document {
  _id: Types.ObjectId;
  schoolId: Types.ObjectId;
  subscriptionId: Types.ObjectId;
  paymentMethodId: Types.ObjectId;
  amount: number;
  transactionId: string;
  status: "Success" | "Failed";
  paidAt: Date;
}

const VipInvoiceSchema = new Schema<IVipInvoice>(
  {
    _id: { type: Schema.Types.ObjectId, auto: true },
    schoolId: { type: Schema.Types.ObjectId, ref: "School", required: true },
    subscriptionId: {
      type: Schema.Types.ObjectId,
      ref: "SchoolSubscription",
      required: true,
    },
    paymentMethodId: {
      type: Schema.Types.ObjectId,
      ref: "PaymentMethod",
      required: true,
    },
    amount: { type: Number, required: true },
    transactionId: { type: String, required: true },
    status: { type: String, enum: ["Success", "Failed"], required: true },
    paidAt: { type: Date, required: true },
  },
  { timestamps: true }
);

export default mongoose.model<IVipInvoice>("VipInvoice", VipInvoiceSchema);
