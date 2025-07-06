import mongoose, { Schema, Document, Types } from 'mongoose';

export interface IClass extends Document {
  name: string;
  code: string;
  schoolId: Types.ObjectId;
  teacherId?: Types.ObjectId;
  students: Types.ObjectId[];
  baseFee: number; // Học phí mặc định của lớp
}

const ClassSchema = new Schema<IClass>({
  name: { type: String, required: true },
  code: { type: String, required: true, unique: true },
  schoolId: { type: Schema.Types.ObjectId, ref: 'School', required: true },
  teacherId: { type: Schema.Types.ObjectId, ref: 'User' },
  students: [{ type: Schema.Types.ObjectId, ref: 'User' }],
  baseFee: { type: Number, required: true } // ✅ thêm trường học phí mặc định
}, { timestamps: true });

export default mongoose.model<IClass>('Class', ClassSchema);
