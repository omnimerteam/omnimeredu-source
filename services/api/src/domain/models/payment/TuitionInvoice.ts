import mongoose, { Schema, Document, Types } from "mongoose";

export interface ITuitionInvoice extends Document {
  _id: Types.ObjectId;
  studentId: Types.ObjectId;
  tuitionId: Types.ObjectId;
  paymentMethodId: Types.ObjectId;
  amount: number;
  transactionId: string;
  status: "Success" | "Failed";
  paidAt: Date;
}

const TuitionInvoiceSchema = new Schema<ITuitionInvoice>(
  {
    _id: { type: Schema.Types.ObjectId, auto: true },
    studentId: { type: Schema.Types.ObjectId, ref: "BaseUser", required: true },
    tuitionId: { type: Schema.Types.ObjectId, ref: "Tuition", required: true },
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

export default mongoose.model<ITuitionInvoice>(
  "TuitionInvoice",
  TuitionInvoiceSchema
);
