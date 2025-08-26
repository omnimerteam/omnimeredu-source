import mongoose, { Schema, Document, Types } from "mongoose";

export interface IMembershipRequest extends Document {
  _id: Types.ObjectId;

  userId: Types.ObjectId; // Ai gửi yêu cầu
  schoolId: Types.ObjectId; // Trường muốn tham gia
  classId?: Types.ObjectId; // Nếu xin vào lớp cụ thể

  role: "Student" | "Teacher" | "Staff";
  action: "Enroll" | "Transfer" | "Assign" | "Resign";
  // Enroll = nhập học / nhận công tác
  // Transfer = chuyển trường
  // Assign = phân công giảng dạy/làm việc
  // Resign = nghỉ học / thôi công tác
  status: "Pending" | "Approved" | "Rejected";
  note?: string;

  createdAt: Date;
  updatedAt: Date;
}

const MembershipRequestSchema = new Schema<IMembershipRequest>(
  {
    _id: { type: Schema.Types.ObjectId, auto: true },

    userId: { type: Schema.Types.ObjectId, ref: "BaseUser", required: true },
    schoolId: { type: Schema.Types.ObjectId, ref: "School", required: true },
    classId: { type: Schema.Types.ObjectId, ref: "Class" },

    role: {
      type: String,
      enum: ["Student", "Teacher", "Staff"],
      required: true,
    },
    action: {
      type: String,
      enum: ["Enroll", "Transfer", "Assign", "Resign"],
      required: true,
    },

    status: {
      type: String,
      enum: ["Pending", "Approved", "Rejected"],
      default: "Pending",
    },
    note: { type: String },
  },
  { timestamps: true }
);

export default mongoose.model<IMembershipRequest>(
  "MembershipRequest",
  MembershipRequestSchema
);
