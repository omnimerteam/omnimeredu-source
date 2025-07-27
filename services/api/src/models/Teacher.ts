import { Schema } from "mongoose";
import { BaseUser } from "./BaseUser";

export interface ITeacher {
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
