import mongoose, { Schema, Document, Types } from 'mongoose';

export interface ITeachingAssignment extends Document {
  teacherId: Types.ObjectId;      // Giáo viên dạy lớp
  classId: Types.ObjectId;        // Lớp học được phân công
  subject?: string;               // Môn dạy (nếu cần)
  isMain?: boolean;               // Giáo viên chính phụ trách môn học (nếu có nhiều giáo viên dạy cùng môn, dùng để xác định người chính)
}

const TeachingAssignmentSchema = new Schema<ITeachingAssignment>({
  teacherId: { type: Schema.Types.ObjectId, ref: 'User', required: true },
  classId: { type: Schema.Types.ObjectId, ref: 'Class', required: true },
  subject: { type: String },
  isMain: { type: Boolean, default: false } 
}, { timestamps: true });

export default mongoose.model<ITeachingAssignment>('TeachingAssignment', TeachingAssignmentSchema);
