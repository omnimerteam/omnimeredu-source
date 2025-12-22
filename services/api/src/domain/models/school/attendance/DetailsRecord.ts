import mongoose, { Schema, Document, Types } from "mongoose";
import {
  AttendanceStatusEnum,
  AttendanceStatusTuple,
  AttendanceMethodEnum,
  AttendanceMethodTuple,
} from "../../../../common/enum/attendanceStatus.enum";

// Attendance proof for QR scans
export interface IAttendanceProof {
  method: AttendanceMethodEnum;
  scanTime?: Date;
  location?: {
    latitude: number;
    longitude: number;
    distance?: number; // Calculated distance from school
  };
  deviceId?: string;
  isOfflineSync?: boolean;
}

export interface IDetailsRecord extends Document {
  _id: Types.ObjectId;
  studentId: Types.ObjectId;
  attendanceId: Types.ObjectId;

  status: AttendanceStatusEnum;
  note?: string;
  attendanceProof?: IAttendanceProof;
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
      enum: AttendanceStatusTuple,
      default: AttendanceStatusEnum.Present,
      required: true,
    },
    note: String,
    attendanceProof: {
      type: {
        method: {
          type: String,
          enum: AttendanceMethodTuple,
          default: AttendanceMethodEnum.Manual,
        },
        scanTime: { type: Date },
        location: {
          latitude: { type: Number },
          longitude: { type: Number },
          distance: { type: Number },
        },
        deviceId: { type: String },
        isOfflineSync: { type: Boolean, default: false },
      },
      required: false,
    },
  },
  { timestamps: true }
);

export default mongoose.model<IDetailsRecord>(
  "DetailsRecord",
  DetailsRecordSchema
);
