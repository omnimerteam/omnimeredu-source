import mongoose, { Schema, Types } from "mongoose";
import { IBaseUser } from "./BaseUser";
import BaseUser from "./BaseUser";
export interface ITeacher extends IBaseUser {
  literacy?: string;
  subjects?: string[];
  schoolId?: Schema.Types.ObjectId;
}

const Teacher = BaseUser.discriminator<ITeacher>(
  "Teacher",
  new Schema<ITeacher>({
    literacy: { type: String, required: false },
    subjects: { type: [String], required: false },
    schoolId: { type: Schema.Types.ObjectId, ref: "School", required: false },
  })
);

export default Teacher;
