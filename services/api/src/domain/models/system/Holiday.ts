import mongoose, { Schema, Document, Types } from "mongoose";

export interface IHoliday extends Document {
  _id: Types.ObjectId;
  schoolId?: Types.ObjectId; // Nếu là ngày lễ riêng của trường
  name: string; // Ví dụ: "Giải phóng miền Nam"
  startDate: Date; // Ngày bắt đầu kỳ nghỉ
  endDate: Date;   // Ngày kết thúc kỳ nghỉ
  isRecurring: boolean; // Lặp lại hằng năm (vd: Tết, 30/4, 1/5)
  type: "national" | "school"; // phân biệt ngày lễ toàn quốc và riêng trường
}

const HolidaySchema = new Schema<IHoliday>(
  {
    _id: { type: Schema.Types.ObjectId, auto: true },
    schoolId: { type: Schema.Types.ObjectId, ref: "School" },
    name: { type: String, required: true, trim: true },
    startDate: { type: Date, required: true },
    endDate:  { type: Date, required: true },
    isRecurring: { type: Boolean, default: false },
    type: { type: String, enum: ["national", "school"], default: "national" },
  },
  { timestamps: true }
);

HolidaySchema.index({ date: 1, schoolId: 1 });

export default mongoose.model<IHoliday>("Holiday", HolidaySchema);