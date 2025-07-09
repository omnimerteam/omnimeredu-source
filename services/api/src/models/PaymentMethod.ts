import mongoose, { Schema, Document } from 'mongoose';

export interface IPaymentMethod extends Document {
  name: 'Momo' | 'ZaloPay' | 'Bank' | 'QRCode';
  description?: string;
}

const PaymentMethodSchema = new Schema<IPaymentMethod>({
  name: { type: String, enum: ['Momo', 'ZaloPay', 'Bank', 'QRCode'], unique: true, required: true },
  description: String
});

export default mongoose.model<IPaymentMethod>('PaymentMethod', PaymentMethodSchema);
