import { Schema, Types } from "mongoose";
import { BaseUser, IBaseUser } from "./BaseUser";

export interface IStudent extends IBaseUser {
  schoolId: Types.ObjectId;
  classId: Types.ObjectId;
}

export const Student = BaseUser.discriminator<IStudent>(
  "Student",
  new Schema<IStudent>({
    schoolId: { type: Schema.Types.ObjectId, ref: "School", required: true },
    classId: { type: Schema.Types.ObjectId, ref: "Class", required: true },
  })
);