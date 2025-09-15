import mongoose, { Schema, Document, Types } from "mongoose";
import {
  EducationSystemLevelsEnum,
  EducationSystemLevelsTuple,
} from "../../../common/enum/educationSystemLevels.enum";

export interface ISchool extends Document {
  _id: Types.ObjectId;
  // Thông tin cơ bản của trường
  name: string;
  code: string;
  address: string;
  phone?: string;
  description?: string;
  level: EducationSystemLevelsEnum;
  adminId?: Types.ObjectId;
  logoUrl?: string;
  // Thông tin systems
  studentCount: number;
  customTheme?: object;
}

const SchoolSchema = new Schema<ISchool>(
  {
    _id: { type: Schema.Types.ObjectId, auto: true },
    // Thông tin cơ bản của trường
    name: { type: String, required: true },
    code: { type: String, required: true, unique: true, index: true },
    address: { type: String, required: true },
    phone: String,
    description: String,
    level: {
      type: String,
      enum: EducationSystemLevelsTuple,
      required: true,
      index: true,
    },
    adminId: { type: Schema.Types.ObjectId, ref: "BaseUser" },
    logoUrl: String,
    // Thông tin systems
    studentCount: { type: Number, default: 0 },
    customTheme: Object,
  },
  { timestamps: true }
);

export default mongoose.model<ISchool>("School", SchoolSchema);
