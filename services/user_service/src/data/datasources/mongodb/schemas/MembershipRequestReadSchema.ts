import { Schema } from "mongoose";
import { mongooseInstance as mongoose } from "shared-lib";

const MembershipRequestReadSchema = new Schema(
  {
    _id: { type: String },
    userId: { type: String, required: true },
    schoolId: { type: String, required: true },
    classId: { type: String },
    role: { type: String, required: true },
    action: { type: String, required: true },
    status: { type: String, required: true },
    note: String,
  },
  {
    timestamps: true,
    _id: false,
  }
);

export const MembershipRequestReadModel = mongoose.model(
  "membership_requests",
  MembershipRequestReadSchema
);
