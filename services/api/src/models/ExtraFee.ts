import mongoose, { Schema, Document, Types } from 'mongoose';

export interface IExtraFee extends Document {
  name: string;
  amount: number;
  applicableTo: Types.ObjectId[];
}

const ExtraFeeSchema = new Schema<IExtraFee>({
  name: { type: String, required: true },
  amount: { type: Number, required: true },
  applicableTo: [{ type: Schema.Types.ObjectId, ref: 'User' }]
}, { timestamps: true });

export default mongoose.model<IExtraFee>('ExtraFee', ExtraFeeSchema);