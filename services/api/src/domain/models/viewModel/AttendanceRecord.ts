import mongoose, { Schema, Document, Types } from "mongoose";
import {
  AttendanceStatusEnum,
  AttendanceStatusTuple,
} from "../../../common/enum/attendanceStatus.enum";

// Subdocument: từng học sinh trong attendance
export interface IStudentAttendance {
  _id: Types.ObjectId; // chắc chắn ObjectId
  name: string;
  status: AttendanceStatusEnum;
  note?: string;
}

// Document AttendanceRecord (view)
export interface IAttendanceRecordView extends Document {
  _id: Types.ObjectId; // _id của attendance gốc
  class: {
    _id: Types.ObjectId;
    name: string;
    code: string;
  };
  school: {
    _id: Types.ObjectId;
    name: string;
    code: string;
  };
  date: Date;
  students: IStudentAttendance[];
}

const StudentAttendanceSchema = new Schema<IStudentAttendance>(
  {
    _id: { type: Schema.Types.ObjectId, required: true, ref: "BaseUser" }, // ObjectId của học sinh
    name: { type: String, required: true },
    status: {
      type: String,
      enum: AttendanceStatusTuple,
      required: true,
    },
    note: String,
  },
  { _id: false } // không tạo _id cho subdocument
);

const AttendanceRecordSchema = new Schema<IAttendanceRecordView>(
  {
    _id: Types.ObjectId,
    class: {
      _id: { type: Schema.Types.ObjectId, required: true, ref: "Class" },
      name: { type: String, required: true },
      code: { type: String, required: true },
    },
    school: {
      _id: { type: Schema.Types.ObjectId, required: true, ref: "School" },
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
