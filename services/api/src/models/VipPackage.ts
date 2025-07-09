import mongoose, { Schema, Document } from 'mongoose';

export interface IVipPackage extends Document {
  name: 'Basic' | 'Pro' | 'Enterprise';
  price: number;
  maxStudents: number;
  maxInvoices: number;
  features: string[];
}

const VipPackageSchema = new Schema<IVipPackage>({
  name: { type: String, enum: ['Basic', 'Pro', 'Enterprise'], unique: true, required: true },
  price: Number,
  maxStudents: Number,
  maxInvoices: Number,
  features: [String]
});

export default mongoose.model<IVipPackage>('VipPackage', VipPackageSchema);