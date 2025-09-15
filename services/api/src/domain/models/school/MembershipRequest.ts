import mongoose, { Schema, Document, Types } from "mongoose";
import {
  MembershipActionEnum,
  MembershipActionTuple,
  MembershipRoleEnum,
  MembershipRoleTuple,
  MembershipStatusEnum,
  MembershipStatusTuple,
} from "../../../common/enum/membershipRequest.enum";

/**
 * 🔹 Interface cho Mongo Document
 */
export interface IMembershipRequest extends Document {
  _id: Types.ObjectId;

  userId: Types.ObjectId; // Ai gửi yêu cầu
  schoolId: Types.ObjectId; // Trường muốn tham gia
  classId?: Types.ObjectId; // Nếu xin vào lớp cụ thể

  role: MembershipRoleEnum;
  action: MembershipActionEnum;
  status: MembershipStatusEnum;

  note?: string;

  createdAt: Date;
  updatedAt: Date;
}

/**
 * 🔹 Schema
 */
const MembershipRequestSchema = new Schema<IMembershipRequest>(
  {
    _id: { type: Schema.Types.ObjectId, auto: true },

    userId: { type: Schema.Types.ObjectId, ref: "BaseUser", required: true },
    schoolId: { type: Schema.Types.ObjectId, ref: "School", required: true },
    classId: { type: Schema.Types.ObjectId, ref: "Class" },

    role: {
      type: String,
      enum: MembershipRoleTuple,
      required: true,
    },
    action: {
      type: String,
      enum: MembershipActionTuple,
      required: true,
    },
    status: {
      type: String,
      enum: MembershipStatusTuple,
      default: MembershipStatusEnum.Pending,
    },

    note: { type: String },
  },
  { timestamps: true }
);

export default mongoose.model<IMembershipRequest>(
  "MembershipRequest",
  MembershipRequestSchema
);
