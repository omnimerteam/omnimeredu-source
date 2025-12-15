import { Schema } from "mongoose";
import { mongooseInstance as mongoose } from "shared-lib";
import { UserReadModel } from "./UserReadSchema";

const TeacherReadSchema = new Schema({
  qualification: { type: String },
  subjects: [String],
});

export const TeacherReadModel = UserReadModel.discriminator(
  "Teacher",
  TeacherReadSchema
);
