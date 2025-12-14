import mongoose, { Schema } from "mongoose";

const AttendanceReadSchema = new Schema(
  {
    _id: { type: String },
    classId: { type: String, required: true },
    schoolId: { type: String, required: true },
    date: { type: Date, required: true },
    sessionType: {
      type: String,
      enum: ["regular", "weekend", "holiday", "extra"],
      default: "regular",
    },
  },
  {
    timestamps: true,
    _id: false,
  }
);

AttendanceReadSchema.index({ classId: 1, date: 1 });
AttendanceReadSchema.index({ schoolId: 1, date: 1 });

export const AttendanceReadModel = mongoose.model(
  "attendances",
  AttendanceReadSchema
);
