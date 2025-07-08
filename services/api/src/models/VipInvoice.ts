import mongoose, { Schema, Document, Types } from 'mongoose';

export interface IVipInvoice extends Document {
  schoolId: Types.ObjectId;
  packageId: Types.ObjectId;
  subscriptionId: Types.ObjectId;
  paymentMethodId: Types.ObjectId;
  amount: number;
  transactionId: string;
  status: 'Success' | 'Failed';
  paidAt: Date;
}

const VipInvoiceSchema = new Schema<IVipInvoice>({
  schoolId: { type: Schema.Types.ObjectId, ref: 'School', required: true },
  packageId: { type: Schema.Types.ObjectId, ref: 'VipPackage', required: true },
  subscriptionId: { type: Schema.Types.ObjectId, ref: 'Subscription', required: true },
  paymentMethodId: { type: Schema.Types.ObjectId, ref: 'PaymentMethod', required: true },
  amount: { type: Number, required: true },
  transactionId: { type: String, required: true },
  status: { type: String, enum: ['Success', 'Failed'], required: true },
  paidAt: { type: Date, required: true }
}, { timestamps: true });

export default mongoose.model<IVipInvoice>('VipInvoice', VipInvoiceSchema);