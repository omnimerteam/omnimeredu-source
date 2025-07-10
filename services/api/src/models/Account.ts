import mongoose, { Schema, Document, Types } from 'mongoose';

export interface IAccount extends Document {
  email: string;
  password: string;
  uid: string;              // Mã định danh riêng
  token?: string;           // JWT hoặc refresh token
  userId: Types.ObjectId;   // Liên kết với người dùng
  username: string;
}

const AccountSchema = new Schema<IAccount>({
  email: { type: String, required: true, unique: true },
  password: { type: String, required: true },
  uid: { type: String, required: true, unique: true },
  token: { type: String },
  username: { type: String, required: true, unique: true }, 
  userId: { type: Schema.Types.ObjectId, ref: 'User', required: true }
}, { timestamps: true });

export default mongoose.model<IAccount>('Account', AccountSchema);
