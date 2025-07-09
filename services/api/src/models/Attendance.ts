import mongoose, { Schema, Document, Types } from 'mongoose';

export interface IAttendance extends Document {
  classId: Types.ObjectId;
  date: Date;
}

const AttendanceSchema = new Schema<IAttendance>({
  classId: { type: Schema.Types.ObjectId, ref: 'Class', required: true },
  date: { type: Date, required: true }
}, { timestamps: true });

export default mongoose.model<IAttendance>('Attendance', AttendanceSchema);
