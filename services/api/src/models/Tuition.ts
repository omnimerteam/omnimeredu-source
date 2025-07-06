import mongoose, { Schema, Document, Types } from 'mongoose';

export interface ITuition extends Document {
  studentId: Types.ObjectId;
  month: string;
  extraFeeIds: Types.ObjectId[];
  discountId?: Types.ObjectId;
  totalAmount: number;
  attendedDays: number; //Tổng số ngày học sinh có mặt trong tháng
  status: 'paid' | 'pending';
}

const TuitionSchema = new Schema<ITuition>({
  studentId: { type: Schema.Types.ObjectId, ref: 'User', required: true },
  month: { type: String, required: true },
  extraFeeIds: [{ type: Schema.Types.ObjectId, ref: 'ExtraFee' }],
  discountId: { type: Schema.Types.ObjectId, ref: 'DiscountPolicy' },
  totalAmount: { type: Number, required: true },
  attendedDays: { type: Number, default: 0 }, //thêm
  status: { type: String, enum: ['paid', 'pending'], default: 'pending' }
}, { timestamps: true });

export default mongoose.model<ITuition>('Tuition', TuitionSchema);
