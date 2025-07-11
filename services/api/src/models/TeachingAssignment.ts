import mongoose, { Schema, Document, Types } from 'mongoose';

export interface ITeachingAssignment extends Document {
  _id: Types.ObjectId;
  teacherId: Types.ObjectId;
  classId: Types.ObjectId;
  subject?: string;
  isMain?: boolean;
}

const TeachingAssignmentSchema = new Schema<ITeachingAssignment>({
  _id: { type: Schema.Types.ObjectId, auto: true },
  teacherId: { type: Schema.Types.ObjectId, ref: 'User', required: true },
  classId: { type: Schema.Types.ObjectId, ref: 'Class', required: true },
  subject: { type: String },
  isMain: { type: Boolean, default: false }
}, { timestamps: true });

export default mongoose.model<ITeachingAssignment>('TeachingAssignment', TeachingAssignmentSchema);
