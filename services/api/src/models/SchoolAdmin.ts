import { Schema, Types } from "mongoose";
import { IBaseUser } from "./BaseUser";
import BaseUser from "./BaseUser";

export interface ISchoolAdmin extends IBaseUser {
  schoolId?: Types.ObjectId;
}

const SchoolAdmin = BaseUser.discriminator<ISchoolAdmin>(
  "SchoolAdmin",
  new Schema<ISchoolAdmin>({
    schoolId: { type: Schema.Types.ObjectId, ref: "School", required: false },
  })
);

export default SchoolAdmin;
