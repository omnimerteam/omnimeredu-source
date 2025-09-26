import mongoose, { Schema, Document, Types } from "mongoose";
import {
  SubjectEnum,
  SubjectTuple,
} from "../../../../common/enum/teacher.enum";

export interface ITeachingAssignment extends Document {
  _id: Types.ObjectId;
  teacherId: Types.ObjectId;
  classId: Types.ObjectId;
  schoolId: Types.ObjectId;
  subject?: SubjectEnum;
  isMain?: boolean;
}

const TeachingAssignmentSchema = new Schema<ITeachingAssignment>(
  {
    _id: { type: Schema.Types.ObjectId, auto: true },
    teacherId: { type: Schema.Types.ObjectId, ref: "BaseUser", required: true },
    classId: { type: Schema.Types.ObjectId, ref: "Class", required: true },
    schoolId: { type: Schema.Types.ObjectId, ref: "School", required: true },
    subject: { type: String, enum: SubjectTuple, required: false },
    isMain: { type: Boolean, default: false },
  },
  { timestamps: true }
);

export default mongoose.model<ITeachingAssignment>(
  "TeachingAssignment",
  TeachingAssignmentSchema
);
