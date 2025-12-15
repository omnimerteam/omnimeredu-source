import { Schema } from "mongoose";
import { mongooseInstance as mongoose } from "shared-lib";

const UserReadSchema = new Schema(
  {
    _id: { type: String }, // UUID from Postgres
    fullName: { type: String, required: true },
    roleKey: { type: String, required: true },
    roleId: { type: String, required: true },
    email: { type: String },
    gender: { type: String },
    birthday: Date,
    phone: { type: String },
    address: String,
    isVerified: { type: Boolean, default: false },
    avatarUrl: String,
    schoolId: { type: String },
    deletedAt: { type: Date, default: null },
  },
  {
    timestamps: true,
    _id: false, // We set _id manually
  }
);

// Register model with name 'users' to match the collection name used in SyncService
export const UserReadModel = mongoose.model("users", UserReadSchema);
