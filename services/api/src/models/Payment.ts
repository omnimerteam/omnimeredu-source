import mongoose, { Schema, Document, Types } from 'mongoose';

export interface IPayment extends Document {
  studentId: Types.ObjectId;
  tuitionId: Types.ObjectId;
  amount: number;
  method: 'Momo' | 'ZaloPay' | 'Bank' | 'QRCode';
  transactionId: string;
  status: 'Success' | 'Failed';
  paidAt: Date;
}

const PaymentSchema = new Schema<IPayment>({
  studentId: { type: Schema.Types.ObjectId, ref: 'User', required: true },
  tuitionId: { type: Schema.Types.ObjectId, ref: 'Tuition', required: true },
  amount: { type: Number, required: true },
  method: { type: String, enum: ['Momo', 'ZaloPay', 'Bank', 'QRCode'], required: true },
  transactionId: { type: String, required: true },
  status: { type: String, enum: ['Success', 'Failed'], required: true },
  paidAt: { type: Date, required: true }
}, { timestamps: true });

export default mongoose.model<IPayment>('Payment', PaymentSchema);