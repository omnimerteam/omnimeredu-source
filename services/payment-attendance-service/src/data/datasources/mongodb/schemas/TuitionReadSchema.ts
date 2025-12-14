import mongoose, { Schema } from "mongoose";

const TuitionReadSchema = new Schema(
  {
    _id: { type: String },
    studentId: { type: String, required: true },
    schoolId: { type: String, required: true },
    classId: { type: String, required: true },
    month: String,
    periodStart: Date,
    periodEnd: Date,
    baseFeeSnapshot: { type: Number, required: true },
    extraFeeDetails: [
      {
        feeId: String,
        feeCode: String,
        feeName: String,
        unitAmountSnapshot: Number,
        quantity: Number,
        calculatedAmount: Number,
      },
    ],
    discountDetails: [
      {
        discountId: String,
        discountCode: String,
        discountName: String,
        kind: { type: String, enum: ["Percentage", "Fixed"] },
        valueSnapshot: Number,
        appliedAmount: Number,
      },
    ],
    appliedRules: Schema.Types.Mixed,
    calculationLog: Schema.Types.Mixed,
    totalAmount: { type: Number, required: true },
    attendedDays: { type: Number, default: 0 },
    currency: { type: String, enum: ["VND", "USD"], default: "VND" },
    status: {
      type: String,
      enum: ["Draft", "Pending", "Paid", "Cancelled", "Failed"],
      default: "Draft",
    },
    createdBy: String,
    confirmedBy: String,
    confirmedAt: Date,
    paidAt: Date,
    invoiceId: String,
    dueDate: Date,
    meta: Schema.Types.Mixed,
  },
  {
    timestamps: true,
    _id: false,
  }
);

TuitionReadSchema.index({ studentId: 1, periodStart: 1 });
TuitionReadSchema.index({ schoolId: 1, periodStart: 1 });
TuitionReadSchema.index({ status: 1 });

export const TuitionReadModel = mongoose.model("tuitions", TuitionReadSchema);
