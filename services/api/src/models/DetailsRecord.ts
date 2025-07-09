import mongoose, { Schema, Document, Types } from 'mongoose';

export interface IDetailsRecord extends Document {
  studentId: Types.ObjectId;
  attendanceId: Types.ObjectId;
  status: 'Present' | 'AbsentWithLeave' | 'Absent';
  note?: string;
}

const DetailsRecordSchema = new Schema<IDetailsRecord>({
  studentId: { type: Schema.Types.ObjectId, ref: 'User', required: true },
  attendanceId: { type: Schema.Types.ObjectId, ref: 'Attendance', required: true },
  status: { type: String, enum: ['Present', 'AbsentWithLeave', 'Absent'], required: true },
  note: String
}, { timestamps: true });

export default mongoose.model<IDetailsRecord>('DetailsRecord', DetailsRecordSchema);
