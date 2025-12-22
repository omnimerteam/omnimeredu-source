import mongoose, { Schema } from "mongoose";

const HolidayReadSchema = new Schema(
  {
    _id: { type: String },
    schoolId: String,
    name: { type: String, required: true },
    date: { type: Date, required: true },
    isRecurring: { type: Boolean, default: false },
    type: { type: String, enum: ["national", "school"], default: "national" },
  },
  {
    timestamps: true,
    _id: false,
  }
);

HolidayReadSchema.index({ date: 1, schoolId: 1 });
HolidayReadSchema.index({ type: 1 });

export const HolidayReadModel = mongoose.model("holidays", HolidayReadSchema);
