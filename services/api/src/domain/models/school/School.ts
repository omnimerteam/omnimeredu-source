import mongoose, { Schema, Document, Types } from "mongoose";

export interface ISchool extends Document {
  _id: Types.ObjectId;
  // Thông tin cơ bản của trường
  name: string;
  code: string;
  address: string;
  phone?: string;
  description?: string;
  level: "Preschool" | "Primary" | "Secondary" | "HighSchool" | "University";
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
    code: { type: String, required: true, unique: true },
    address: { type: String, required: true },
    phone: String,
    description: String,
    level: {
      type: String,
      enum: ["Preschool", "Primary", "Secondary", "HighSchool", "University"],
      required: true,
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
