import mongoose, { Schema } from "mongoose";

const AttendanceRecordReadSchema = new Schema(
  {
    _id: { type: String },
    studentId: { type: String, required: true },
    attendanceId: { type: String, required: true },
    status: {
      type: String,
      enum: ["Present", "AbsentWithLeave", "Absent", "Late", "LeftEarly"],
      default: "Present",
    },
    note: String,
  },
  {
    timestamps: true,
    _id: false,
  }
);

AttendanceRecordReadSchema.index({ attendanceId: 1 });
AttendanceRecordReadSchema.index({ studentId: 1 });

export const AttendanceRecordReadModel = mongoose.model(
  "attendance_records",
  AttendanceRecordReadSchema
);
