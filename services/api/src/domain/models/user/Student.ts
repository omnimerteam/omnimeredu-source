import { Schema, Types } from "mongoose";
import { IBaseUser } from "./BaseUser";
import BaseUser from "./BaseUser";
import {
  EducationGradesEnum,
  EducationGradesTuple,
  EducationSystemLevelsEnum,
  EducationSystemLevelsTuple,
} from "../../../common/enum/educationSystemLevels.enum";

/**
 * Interface đại diện cho Student (học sinh), kế thừa từ IBaseUser
 */
export interface IStudent extends IBaseUser {
  classId?: Types.ObjectId | null;
  educationLevel: EducationSystemLevelsEnum;
  gradeGroup: EducationGradesEnum;

  guardianName?: string;
  guardianPhone?: string;

  meta?: Record<string, any>; // thông tin tự do (siblings, mealPlan, pickupService,...)
}
/**
 * Schema cho Student (kế thừa từ BaseUser)
 */
const StudentSchema = new Schema<IStudent>(
  {
    classId: {
      type: Schema.Types.ObjectId,
      ref: "Class",
      default: null,
      index: true,
    },
    guardianName: { type: String, trim: true },
    guardianPhone: { type: String, trim: true },

    educationLevel: {
      type: String,
      enum: EducationSystemLevelsTuple,
      required: true,
      index: true,
    },

    gradeGroup: {
      type: String,
      enum: EducationGradesTuple,
      required: true,
      index: true,
    },

    meta: {
      type: Schema.Types.Mixed,
      default: {},
    },
  },
  { timestamps: true }
);

/**
 * Discriminator Student từ BaseUser
 */
const Student = BaseUser.discriminator<IStudent>("Student", StudentSchema);

export default Student;
