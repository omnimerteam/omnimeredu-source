import { Schema, Types } from "mongoose";
import { BaseUser, IBaseUser } from "./BaseUser";

export interface ISchoolAdmin extends IBaseUser {
  schoolId?: Types.ObjectId;
}

export const SchoolAdmin = BaseUser.discriminator<ISchoolAdmin>(
  "SchoolAdmin",
  new Schema<ISchoolAdmin>({
    schoolId: { type: Schema.Types.ObjectId, ref: "School", required: false },
  })
);
