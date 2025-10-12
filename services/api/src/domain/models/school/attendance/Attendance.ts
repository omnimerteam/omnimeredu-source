import mongoose, { Schema, Document, Types, now } from "mongoose";
import {
  AttendanceAttendanceSessionTypeTuple,
  AttendanceSessionTypeEnum,
} from "../../../../common/enum/attendanceStatus.enum";

export interface IAttendance extends Document {
  _id: Types.ObjectId;
  classId: Types.ObjectId;
  schoolId: Types.ObjectId;
  sessionType: AttendanceSessionTypeEnum;
  date: Date;
}

const AttendanceSchema = new Schema<IAttendance>(
  {
    _id: { type: Schema.Types.ObjectId, auto: true },
    classId: { type: Schema.Types.ObjectId, ref: "Class", required: true },
    schoolId: { type: Schema.Types.ObjectId, ref: "School", required: true },
    sessionType: {
      type: String,
      enum: AttendanceAttendanceSessionTypeTuple,
      default: AttendanceSessionTypeEnum.regular,
      required: true,
    },
    date: { type: Date, required: true, default: Date.now },
  },
  { timestamps: true }
);

export default mongoose.model<IAttendance>("Attendance", AttendanceSchema);
