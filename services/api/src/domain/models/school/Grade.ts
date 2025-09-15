import mongoose, { Schema, Document, Types } from "mongoose";
import {
  EducationSystemLevelsEnum,
  EducationSystemLevelsTuple,
} from "../../../common/enum/educationSystemLevels.enum";

export interface IGrade extends Document {
    _id: Types.ObjectId;
    schoolId?: Types.ObjectId;             // null = khối chuẩn chung
    name: string;                          // tên khối (Chồi, Lá, Mầm…)
    level: EducationSystemLevelsEnum;
    order: number;                         // thứ tự hiển thị
    ageRange?: { min: number; max: number }; // độ tuổi học sinh
    description?: string;                  // mô tả chi tiết khối
    customFields?: Record<string, any>;    // lưu các thông tin đặc thù riêng của trường
    status: "active" | "inactive";         // để quản lý khối tạm ngưng
    linkedClasses?: Types.ObjectId[];      // optional, các lớp liên kết sẵn với khối
}

const GradeSchema = new Schema<IGrade>(
  {
    _id: { type: Schema.Types.ObjectId, auto: true },
    schoolId: { type: Schema.Types.ObjectId, ref: "School", default: null },
    name: { type: String, required: true },
    level: {
      type: String,
      enum: EducationSystemLevelsTuple,
      required: true,
      index: true,
    },
    order: { type: Number, required: true },
    ageRange: {
      min: { type: Number },
      max: { type: Number },
    },
    description: { type: String },
    customFields: { type: Object, default: {} },
    status: { type: String, enum: ["active", "inactive"], default: "active" },
    linkedClasses: [{ type: Schema.Types.ObjectId, ref: "Class" }],
  },
  { timestamps: true }
);

export default mongoose.model<IGrade>("Grade", GradeSchema);