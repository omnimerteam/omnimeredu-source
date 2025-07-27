import mongoose, { Schema, Types } from "mongoose";
import { BaseUser, IBaseUser } from "./BaseUser";

export interface ITeacher extends IBaseUser {
  literacy: string;
  subjects: string[];
  schoolId: Types.ObjectId;
}

// Define schema for the discriminator
const TeacherSchema = new Schema<ITeacher>({
  literacy: { type: String },
  subjects: [{ type: String }],
  schoolId: { type: Schema.Types.ObjectId, ref: "School", required: true },
});

export default BaseUser.discriminator<ITeacher>("Teacher", TeacherSchema);

