import mongoose, { Schema } from "mongoose";

const ClassReadSchema = new Schema(
  {
    _id: { type: String },
    name: { type: String, required: true },
    code: { type: String, required: true },
    schoolId: { type: String, required: true },
    gradeId: { type: String, required: true },
    maxStudents: { type: Number, default: 30 },
    baseFee: { type: Number, default: 0 },
  },
  {
    timestamps: true,
    _id: false,
  }
);

export const ClassReadModel = mongoose.model("classes", ClassReadSchema);
