import mongoose, { Schema } from "mongoose";

const GradeReadSchema = new Schema(
  {
    _id: { type: String },
    schoolId: { type: String, required: true },
    name: { type: String, required: true },
    level: { type: String, required: true },
    gradeGroup: { type: String, required: true },
    order: { type: Number, required: true },
    active: { type: Boolean, default: true },
    ageRange: Object,
    description: String,
    customFields: Object,
  },
  {
    timestamps: true,
    _id: false,
  }
);

export const GradeReadModel = mongoose.model("grades", GradeReadSchema);
