import { Schema, Types } from "mongoose";
import { IBaseUser } from "./BaseUser";
import BaseUser from "./BaseUser";
import {
  EducationSystemLevelsEnum,
  EducationSystemLevelsTuple,
} from "../../../common/enum/educationSystemLevels.enum";

/**
 * Interface đại diện cho Student (học sinh), kế thừa từ IBaseUser
 */
export interface IStudent extends IBaseUser {
  classId?: Types.ObjectId;
  guardianName?: string;
  guardianPhone?: string;
  educationLevel: EducationSystemLevelsEnum;
  grade?: string;
  registeredExtraFees?: {
    extraFeeId: Types.ObjectId;
    amount: number; // số tiền áp dụng cho học sinh này
  }[];
  registeredDiscounts?: Types.ObjectId[];
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
    amount: { type: Number, required: true, min: 0 },
  },
  { _id: false }
);

/**
 * Schema cho Student
 */
const StudentSchema = new Schema<IStudent>({
  classId: {
    type: Schema.Types.ObjectId,
    ref: "Class",
    default: null,
    index: true,
  },
  guardianName: { type: String },
  guardianPhone: { type: String },
  educationLevel: {
    type: String,
    enum: EducationSystemLevelsTuple,
    required: true,
    index: true,
  },
  grade: { type: String },

  // phí đăng ký (có amount riêng cho từng học sinh)
  registeredExtraFees: [RegisteredExtraFeeSchema],

  // giảm giá đăng ký (chỉ lưu ID policy)
  registeredDiscounts: [{ type: Schema.Types.ObjectId, ref: "DiscountPolicy" }],
});

/**
 * Tạo discriminator Student dựa trên BaseUser
 */
const Student = BaseUser.discriminator<IStudent>("Student", StudentSchema);

export default Student;
