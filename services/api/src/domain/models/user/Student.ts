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

  registeredExtraFees?: {
    extraFeeId: Types.ObjectId;
    amount: number;
    quantity?: number;
  }[];

  registeredDiscounts?: {
    discountId: Types.ObjectId;
    params?: Record<string, any>;
  }[];

  meta?: Record<string, any>; // thông tin tự do (siblings, mealPlan, pickupService,...)
}

/**
 * Subschema cho registeredExtraFees
 */
const RegisteredExtraFeeSchema = new Schema(
  {
    extraFeeId: {
      type: Schema.Types.ObjectId,
      ref: "ExtraFee",
      required: true,
    },
    amount: {
      type: Number,
      required: true,
      min: 0,
    },
    quantity: {
      type: Number,
      default: 1,
      min: 0,
    },
  },
  { _id: false }
);

/**
 * Subschema cho registeredDiscounts
 */
const RegisteredDiscountSchema = new Schema(
  {
    discountId: {
      type: Schema.Types.ObjectId,
      ref: "DiscountPolicy",
      required: true,
    },
    params: {
      type: Schema.Types.Mixed, // có thể lưu các biến tuỳ chỉnh như { siblings: 2, validUntil: '2025-12-31' }
      default: {},
    },
  },
  { _id: false }
);

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

    registeredExtraFees: {
      type: [RegisteredExtraFeeSchema],
      default: [],
    },

    registeredDiscounts: {
      type: [RegisteredDiscountSchema],
      default: [],
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
