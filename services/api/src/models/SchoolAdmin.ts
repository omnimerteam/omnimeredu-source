import { Schema, Types } from "mongoose";
import { IBaseUser } from "./BaseUser";
import BaseUser from "./BaseUser";

export interface ISchoolAdmin extends IBaseUser {
  userId?: Types.ObjectId; // Reference to the user document
  schoolId?: Types.ObjectId;
}

const SchoolAdmin = BaseUser.discriminator<ISchoolAdmin>(
  "SchoolAdmin",
  new Schema<ISchoolAdmin>({
    userId: { type: Schema.Types.ObjectId, ref: "User", required: false }, // Reference to the user document
    schoolId: { type: Schema.Types.ObjectId, ref: "School", required: false },
  })
);

export default SchoolAdmin;
