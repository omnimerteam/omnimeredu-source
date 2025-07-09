import mongoose, { Schema, Document, Types } from 'mongoose';

export interface IDiscountPolicy extends Document {
  name: string;
  type: 'percentage' | 'fixed';
  value: number;
  applicableTo: Types.ObjectId[];
}

const DiscountPolicySchema = new Schema<IDiscountPolicy>({
  name: { type: String, required: true },
  type: { type: String, enum: ['percentage', 'fixed'], required: true },
  value: { type: Number, required: true },
  applicableTo: [{ type: Schema.Types.ObjectId, ref: 'User' }]
}, { timestamps: true });

export default mongoose.model<IDiscountPolicy>('DiscountPolicy', DiscountPolicySchema);