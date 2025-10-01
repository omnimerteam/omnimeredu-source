import mongoose, { Schema, Document, Types } from "mongoose";
import {
  AttendanceStatusEnum,
  AttendanceStatusTuple,
} from "../../../common/enum/attendanceStatus.enum";

// Subdocument: từng học sinh trong attendance
export interface IStudentAttendance {
  _id: Types.ObjectId; // chắc chắn ObjectId
  name: string;
  phone?: string;
  guardianName: string;
  guardianPhone: string;
  gender?: string;
  birthday?: Date;
  detailRecordId: Types.ObjectId;
  status: AttendanceStatusEnum;
  note?: string;
}

// Document AttendanceRecord (view)
export interface IAttendanceRecordView extends Document {
  _id: Types.ObjectId; // _id của attendance gốc
  classId: Types.ObjectId;
  schoolId: Types.ObjectId;
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
    phone: { type: String, required: false },
    guardianName: { type: String, required: true },
    guardianPhone: { type: String, required: true },
    gender: { type: String, required: false },
    birthday: { type: Date, required: false },
    detailRecordId: {
      type: Schema.Types.ObjectId,
      required: true,
      ref: "DetailsRecord",
    },
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
    _id: { type: Schema.Types.ObjectId, required: true },
    classId: { type: Schema.Types.ObjectId, required: true, ref: "Class" },
    schoolId: { type: Schema.Types.ObjectId, required: true, ref: "School" },
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
