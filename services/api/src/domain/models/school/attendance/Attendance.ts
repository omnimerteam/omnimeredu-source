import mongoose, { Schema, Document, Types, now } from "mongoose";
import {
  AttendanceAttendanceSessionTypeTuple,
  AttendanceSessionTypeEnum,
} from "../../../../common/enum/attendanceStatus.enum";

// QR Config for attendance session
export interface IQRConfig {
  code: string; // Current QR code seed/payload
  expiry: Date; // When this QR expires
  dynamicCode?: string; // Rotating code for extra security
  location?: {
    latitude: number;
    longitude: number;
    radius: number; // Allowed radius in meters
  };
}

export interface IAttendance extends Document {
  _id: Types.ObjectId;
  classId: Types.ObjectId;
  schoolId: Types.ObjectId;
  date: Date;
  sessionType: AttendanceSessionTypeEnum;
  qrConfig?: IQRConfig;
}

const AttendanceSchema = new Schema<IAttendance>(
  {
    _id: { type: Schema.Types.ObjectId, auto: true },
    classId: { type: Schema.Types.ObjectId, ref: "Class", required: true },
    schoolId: { type: Schema.Types.ObjectId, ref: "School", required: true },
    date: { type: Date, required: true, default: Date.now },
    sessionType: {
      type: String,
      enum: AttendanceAttendanceSessionTypeTuple,
      default: AttendanceSessionTypeEnum.regular,
      required: true,
    },
    qrConfig: {
      type: {
        code: { type: String },
        expiry: { type: Date },
        dynamicCode: { type: String },
        location: {
          latitude: { type: Number },
          longitude: { type: Number },
          radius: { type: Number, default: 100 }, // Default 100 meters
        },
      },
      required: false,
    },
  },
  { timestamps: true }
);

export default mongoose.model<IAttendance>("Attendance", AttendanceSchema);
