import mongoose, { Schema, Types, Document } from "mongoose";
import {
  SubjectEnum,
  SubjectTuple,
  TeacherQualificationEnum,
  TeacherQualificationTuple,
} from "../../../common/enum/teacher.enum";

export interface IClassDetailView extends Document {
  _id: Types.ObjectId;
  name: string;
  code: string;
  baseFee?: number;

  school: {
    _id: Types.ObjectId;
    name: string;
    code: string;
    level: string;
  } | null;

  grade: {
    _id: Types.ObjectId;
    name: string;
    level: string;
  } | null;

  teachers:
    | [
        {
          _id: Types.ObjectId;
          fullName: string;
          subject?: SubjectEnum;
          qualification?: TeacherQualificationEnum;
          isMain: boolean;
        }
      ]
    | null;

  students:
    | [
        {
          _id: Types.ObjectId;
          fullName: string;
          gender?: string;
          phone?: string;
          address?: string;
          guardianName?: string;
          guardianPhone?: string;
        }
      ]
    | null;
}

const ClassDetailSchema = new Schema<IClassDetailView>(
  {
    _id: { type: Schema.Types.ObjectId, ref: "Class" },
    name: { type: String },
    code: { type: String },
    baseFee: { type: Number },

    // school info
    school: {
      _id: { type: Schema.Types.ObjectId, ref: "School" },
      name: { type: String },
      code: { type: String },
      level: { type: String },
    },

    // grade info
    grade: {
      _id: { type: Schema.Types.ObjectId, ref: "Grade" },
      name: { type: String },
      level: { type: String },
    },

    // main teacher info
    teachers: [
      {
        _id: { type: Schema.Types.ObjectId, ref: "BaseUser" },
        fullName: { type: String },
        subject: { type: String, enum: SubjectTuple },
        qualification: { type: String, enum: TeacherQualificationTuple },
      },
    ],

    // students array (just ids in projection)
    students: [
      {
        _id: { type: Schema.Types.ObjectId, ref: "BaseUser" },
        fullName: { type: String },
        literacy: { type: String },
        qualification: { type: String },
      },
    ],
  },
  { collection: "ClassDetail", timestamps: false }
);

export default mongoose.model<IClassDetailView>(
  "ClassDetailView",
  ClassDetailSchema
);
