import mongoose, { Schema, Document, Types } from "mongoose";

export interface ISchoolSubscription extends Document {
  _id: Types.ObjectId;
  schoolId: Types.ObjectId;
  packageId: Types.ObjectId;
  activatedAt: Date;
  expiresAt: Date;
  isActive: boolean;
}

const SchoolSubscriptionSchema = new Schema<ISchoolSubscription>(
  {
    _id: { type: Schema.Types.ObjectId, auto: true },
    schoolId: { type: Schema.Types.ObjectId, ref: "School", required: true },
    packageId: {
      type: Schema.Types.ObjectId,
      ref: "VipPackage",
      required: true,
    },
    activatedAt: { type: Date, default: Date.now },
    expiresAt: Date,
    isActive: { type: Boolean, default: true },
  },
  { timestamps: true }
);

export default mongoose.model<ISchoolSubscription>(
  "SchoolSubscription",
  SchoolSubscriptionSchema
);
