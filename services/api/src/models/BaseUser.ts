import mongoose, { Schema, Document, Types } from "mongoose";

export interface IBaseUser extends Document {
  _id: Types.ObjectId;
  fullName: string;
  roleId: Types.ObjectId;
  gender?: "Male" | "Female" | "Other";
  birthday?: Date;
  phone?: string;
  address?: string;
  isVerified?: boolean;
}

const BaseUserSchema = new Schema<IBaseUser>(
  {
    _id: { type: Schema.Types.ObjectId, auto: true },
    fullName: { type: String, required: true },
    roleId: { type: Schema.Types.ObjectId, ref: "Role", required: true },
    gender: { type: String, enum: ["Male", "Female", "Other"] },
    birthday: Date,
    phone: String,
    address: String,
    isVerified: { type: Boolean, default: false },
  },
  {
    discriminatorKey: "roleKey",
    collection: "users",
    timestamps: true,
  }
);
const BaseUserSchema = new Schema<IBaseUser>(
  {
    _id: { type: Schema.Types.ObjectId, auto: true },
    fullName: { type: String, required: true },
    roleId: { type: Schema.Types.ObjectId, ref: "Role", required: true },
    gender: { type: String, enum: ["Male", "Female", "Other"] },
    birthday: Date,
    phone: String,
    address: String,
    isVerified: { type: Boolean, default: false },
  },
  {
    discriminatorKey: "roleKey",
    collection: "users",
    timestamps: true,
  }
);

export const BaseUser = mongoose.model<IBaseUser>("User", BaseUserSchema);
