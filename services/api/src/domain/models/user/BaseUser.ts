import mongoose, { Schema, Document, Types } from "mongoose";
import { IRole } from "./Role";
import { GenderEnum, GenderTuple } from "../../../common/enum/gender.enum";

export interface IBaseUser extends Document {
  _id: Types.ObjectId;
  fullName: string;
  roleId: Types.ObjectId | IRole;
  gender?: GenderEnum;
  birthday?: Date;
  phone?: string;
  address?: string;
  isVerified?: boolean;
  schoolId?: Types.ObjectId | null;
  avatarUrl?: string;
  roleKey?: String;
}

const BaseUserSchema = new Schema<IBaseUser>(
  {
    _id: { type: Schema.Types.ObjectId, auto: true },
    fullName: { type: String, required: true, index: true },
    roleId: {
      type: Schema.Types.ObjectId,
      ref: "Role",
      required: true,
      index: true,
    }, //thêm index
    gender: {
      type: String,
      enum: GenderTuple,
      default: "Male",
    },
    birthday: Date,
    phone: { type: String, index: true },
    address: String,
    isVerified: { type: Boolean, default: false, index: true },
    schoolId: {
      type: Schema.Types.ObjectId,
      ref: "School",
      default: null,
      required: false,
      index: true,
    },
    avatarUrl: {
      type: String,
      default: null,
    },

    roleKey: { type: String, default: null },
  },
  {
    discriminatorKey: "roleKey",
    collection: "users",
    timestamps: true,
  }
);

export default mongoose.model<IBaseUser>("BaseUser", BaseUserSchema);
