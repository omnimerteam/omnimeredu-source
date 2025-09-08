import mongoose, { Schema, Document, Types } from "mongoose";
import { AttendanceStatus } from "../../../common/enum/attendanceStatus.enum";

// Subdocument: từng học sinh trong attendance
export interface IStudentAttendance {
  id: Types.ObjectId; // chắc chắn ObjectId
  name: string;
  status: AttendanceStatus;
  note?: string;
}

// Document AttendanceRecord (view)
export interface IAttendanceRecordView extends Document {
  _id: Types.ObjectId; // _id của attendance gốc
  classId: {
    name: string;
    code: string;
  };
  schoolId: {
    name: string;
    code: string;
  };
  date: Date;
  students: IStudentAttendance[];
}

const StudentAttendanceSchema = new Schema<IStudentAttendance>(
  {
    id: { type: Schema.Types.ObjectId, required: true, ref: "BaseUser" }, // ObjectId của học sinh
    name: { type: String, required: true },
    status: {
      type: String,
      enum: Object.values(AttendanceStatus),
      required: true,
    },
    note: String,
  },
  { _id: false } // không tạo _id cho subdocument
);

const AttendanceRecordSchema = new Schema<IAttendanceRecordView>(
  {
    classId: {
      name: { type: String, required: true },
      code: { type: String, required: true },
    },
    schoolId: {
      name: { type: String, required: true },
      code: { type: String, required: true },
    },
    date: { type: Date, required: true },
    students: [StudentAttendanceSchema],
  },
  {
    collection: "AttendanceRecord", // map tới view trong MongoDB Atlas
    timestamps: false,
  }
);

// Model chỉ đọc
export default mongoose.model<IAttendanceRecordView>(
  "AttendanceRecordView",
  AttendanceRecordSchema
);
