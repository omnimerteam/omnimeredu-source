import { Schema, Types } from "mongoose";
import { IBaseUser } from "./BaseUser";
import BaseUser from "./BaseUser";

export interface IStudent extends IBaseUser {
  schoolId?: Types.ObjectId;
  classId?: Types.ObjectId;
}

const Student = BaseUser.discriminator<IStudent>(
  "Student",
  new Schema<IStudent>({
    schoolId: { type: Schema.Types.ObjectId, ref: "School", required: false },
    classId: { type: Schema.Types.ObjectId, ref: "Class", required: false },
  })
);

export default Student;
