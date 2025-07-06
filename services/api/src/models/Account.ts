import mongoose, { Schema, Document, Types } from 'mongoose';

export interface IAccount extends Document {
  email: string;
  password: string;
  uid: string; // Mã định danh riêng
  token?: string; // Dùng để lưu JWT hoặc refresh token
  userId: Types.ObjectId; // Liên kết với BaseUser
}

const AccountSchema = new Schema<IAccount>({
  email: { type: String, required: true, unique: true },
  password: { type: String, required: true },
  uid: { type: String, required: true, unique: true },
  token: { type: String },
  userId: { type: Schema.Types.ObjectId, ref: 'User', required: true }
}, { timestamps: true });

export default mongoose.model<IAccount>('Account', AccountSchema);