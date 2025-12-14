import mongoose, { Schema } from "mongoose";

const PaymentReadSchema = new Schema(
  {
    _id: { type: String },
    studentId: { type: String, required: true },
    tuitionId: { type: String, required: true },
    paymentMethodId: { type: String, required: true },
    amount: { type: Number, required: true },
    transactionId: { type: String, required: true, unique: true },
    status: { type: String, enum: ["Success", "Failed"], required: true },
    paidAt: { type: Date, required: true },
  },
  {
    timestamps: true,
    _id: false,
  }
);

PaymentReadSchema.index({ tuitionId: 1 });
PaymentReadSchema.index({ studentId: 1 });
PaymentReadSchema.index({ transactionId: 1 }, { unique: true });

export const PaymentReadModel = mongoose.model("payments", PaymentReadSchema);
