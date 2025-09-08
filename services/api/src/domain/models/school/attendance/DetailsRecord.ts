import mongoose, { Schema, Document, Types } from "mongoose";
import { AttendanceStatus } from "../../../../common/enum/attendanceStatus.enum";

export interface IDetailsRecord extends Document {
  _id: Types.ObjectId;
  studentId: Types.ObjectId;
  attendanceId: Types.ObjectId;
  status: AttendanceStatus;
  note?: string;
}

const DetailsRecordSchema = new Schema<IDetailsRecord>(
  {
    _id: { type: Schema.Types.ObjectId, auto: true },
    studentId: { type: Schema.Types.ObjectId, ref: "BaseUser", required: true },
    attendanceId: {
      type: Schema.Types.ObjectId,
      ref: "Attendance",
      required: true,
    },
    status: {
      type: String,
      enum: Object.values(AttendanceStatus),
      required: true,
    },
    note: String,
  },
  { timestamps: true }
);

export default mongoose.model<IDetailsRecord>(
  "DetailsRecord",
  DetailsRecordSchema
);
