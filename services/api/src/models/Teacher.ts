import mongoose, { Schema, Types } from "mongoose";
import { BaseUser, IBaseUser } from "./BaseUser";

export interface ITeacher extends IBaseUser {
  literacy: string;
  subjects: string[];
  schoolId?: Schema.Types.ObjectId;
}

export const Teacher = BaseUser.discriminator(
  "Teacher",
  new Schema({
    literacy: String,
    subjects: [String],
    schoolId: { type: Schema.Types.ObjectId, ref: "School", required: false },
  })
);
