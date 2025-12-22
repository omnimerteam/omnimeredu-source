import { Schema } from "mongoose";
import { mongooseInstance as mongoose } from "shared-lib";

const SchoolReadSchema = new Schema(
  {
    _id: { type: String },
    name: { type: String, required: true },
    code: { type: String, required: true },
    address: { type: String, required: true },
    level: { type: String, required: true },
    adminId: { type: String },
    phone: String,
    description: String,
    logoUrl: String,
    studentCount: { type: Number, default: 0 },
    customTheme: Object,
  },
  {
    timestamps: true,
    _id: false,
  }
);

export const SchoolReadModel = mongoose.model("schools", SchoolReadSchema);
