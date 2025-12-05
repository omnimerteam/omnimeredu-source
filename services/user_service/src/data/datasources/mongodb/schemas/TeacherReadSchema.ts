import mongoose, { Schema } from "mongoose";
import { UserReadModel } from "./UserReadSchema";

const TeacherReadSchema = new Schema({
  qualification: { type: String },
  subjects: [String],
});

export const TeacherReadModel = UserReadModel.discriminator(
  "Teacher",
  TeacherReadSchema
);
