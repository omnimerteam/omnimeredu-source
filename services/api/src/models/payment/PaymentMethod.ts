import mongoose, { Schema, Document, Types } from 'mongoose';

export interface IPaymentMethod extends Document {
  _id: Types.ObjectId;
  name: 'Momo' | 'ZaloPay' | 'Bank' | 'QRCode';
  description?: string;
}

const PaymentMethodSchema = new Schema<IPaymentMethod>({
  _id: { type: Schema.Types.ObjectId, auto: true },
  name: { type: String, enum: ['Momo', 'ZaloPay', 'Bank', 'QRCode'], unique: true, required: true },
  description: String
});

export default mongoose.model<IPaymentMethod>('PaymentMethod', PaymentMethodSchema);