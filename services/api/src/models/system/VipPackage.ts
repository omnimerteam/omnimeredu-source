import mongoose, { Schema, Document, Types } from 'mongoose';

export interface IVipPackage extends Document {
  _id: Types.ObjectId;
  name: 'Basic' | 'Pro' | 'Enterprise';
  price: number;
  maxStudents: number;
  maxInvoices: number;
  features: string[];
}

const VipPackageSchema = new Schema<IVipPackage>({
  _id: { type: Schema.Types.ObjectId, auto: true },
  name: { type: String, enum: ['Basic', 'Pro', 'Enterprise'], unique: true, required: true },
  price: Number,
  maxStudents: Number,
  maxInvoices: Number,
  features: [String]
});

export default mongoose.model<IVipPackage>('VipPackage', VipPackageSchema);