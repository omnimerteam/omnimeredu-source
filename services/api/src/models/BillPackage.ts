import mongoose, { Schema, Document, Types } from 'mongoose';

export interface IBillPackage extends Document {
  schoolId: Types.ObjectId;
  packageId: Types.ObjectId;
  activatedAt: Date;
  expiresAt: Date;
  isActive: boolean;
}

const BillPackageSchema = new Schema<IBillPackage>({
  schoolId: { type: Schema.Types.ObjectId, ref: 'School', required: true },
  packageId: { type: Schema.Types.ObjectId, ref: 'VipPackage', required: true },
  activatedAt: { type: Date, default: Date.now },
  expiresAt: Date,
  isActive: { type: Boolean, default: true }
}, { timestamps: true });

export default mongoose.model<IBillPackage>('BillPackage', BillPackageSchema);
