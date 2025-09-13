import mongoose, { Schema, Types, Document } from "mongoose";

export interface IClassDetailView extends Document {
  _id: Types.ObjectId;
  name: string;
  code: string;
  baseFee: number;
  studentCount: number;
  schoolId: Types.ObjectId;
  schoolName: string;
  schoolLevel: string;
  teacherId: Types.ObjectId;
  teacherName: string;
}

const ClassDetailSchema = new Schema<IClassDetailView>(
  {
    _id: { type: Schema.Types.ObjectId }, // có thể bỏ nếu view đã tự tạo _id
    name: { type: String },
    code: { type: String },
    baseFee: { type: Number },
    studentCount: { type: Number },
    schoolId: { type: Schema.Types.ObjectId },
    schoolName: { type: String },
    schoolLevel: { type: String },
    teacherId: { type: Schema.Types.ObjectId },
    teacherName: { type: String },
  },
  { collection: "ClassDetail", timestamps: false }
);

export default mongoose.model<IClassDetailView>(
  "ClassDetailView",
  ClassDetailSchema
);
