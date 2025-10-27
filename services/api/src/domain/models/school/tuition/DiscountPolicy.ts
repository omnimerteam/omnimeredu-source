import mongoose, { Schema, Document, Types } from "mongoose";
import { ConditionSchema, ICondition } from "./Condition";
import {
  DiscountKindEnum,
  DiscountKindTuple,
  DiscountTargetEnum,
  DiscountTargetTuple,
  DiscountApplicabilityScopeEnum,
  DiscountApplicabilityScopeTuple,
  DiscountOncePerEnum,
  DiscountOncePerTuple,
} from "../../../../common/enum/tuition.enum";

/**
 * Interface đại diện cho một chính sách giảm học phí
 */
export interface IDiscountPolicy extends Document {
  _id: Types.ObjectId;

  code?: string;
  name: string;
  description?: string;

  kind: DiscountKindEnum; // loại giảm giá
  value: number;

  target: DiscountTargetEnum;
  targetFeeCode?: string;
  maxCap?: number;

  stackable?: boolean;
  priority?: number;
  exclusiveGroup?: string;
  oncePer?: DiscountOncePerEnum;

  conditions?: ICondition[];

  applicabilityScope?: DiscountApplicabilityScopeEnum;
  applicableClassIds?: Types.ObjectId[];
  applicableStudentIds?: Types.ObjectId[];
  applicableGradeIds?: Types.ObjectId[];

  schoolId: Types.ObjectId;
  active?: boolean;
  effectiveFrom?: Date;
  effectiveTo?: Date | null;
  minSubtotal?: number;
  maxSubtotal?: number;
}

/**
 * Mongoose Schema cho DiscountPolicy
 */
const DiscountPolicySchema = new Schema<IDiscountPolicy>(
  {
    _id: { type: Schema.Types.ObjectId, auto: true },

    code: { type: String, index: true, unique: true, sparse: true },
    name: { type: String, required: true },
    description: String,

    kind: {
      type: String,
      enum: DiscountKindTuple,
      required: true,
    },
    value: { type: Number, required: true, min: 0 },

    target: {
      type: String,
      enum: DiscountTargetTuple,
      default: DiscountTargetEnum.Subtotal,
    },
    targetFeeCode: String,
    maxCap: Number,

    stackable: { type: Boolean, default: false },
    priority: { type: Number, default: 0 },
    exclusiveGroup: String,

    oncePer: {
      type: String,
      enum: DiscountOncePerTuple,
      default: DiscountOncePerEnum.None,
    },

    conditions: [ConditionSchema],

    applicabilityScope: {
      type: String,
      enum: DiscountApplicabilityScopeTuple,
      default: DiscountApplicabilityScopeEnum.All,
    },
    applicableClassIds: [{ type: Schema.Types.ObjectId, ref: "Class" }],
    applicableStudentIds: [{ type: Schema.Types.ObjectId, ref: "BaseUser" }],
    applicableGradeIds: [{ type: Schema.Types.ObjectId, ref: "Grade" }],

    minSubtotal: Number,
    maxSubtotal: Number,

    schoolId: {
      type: Schema.Types.ObjectId,
      ref: "School",
      required: true,
      index: true,
    },

    active: { type: Boolean, default: true },
    effectiveFrom: { type: Date, default: Date.now },
    effectiveTo: { type: Date, default: null },
  },
  { timestamps: true }
);

export default mongoose.model<IDiscountPolicy>(
  "DiscountPolicy",
  DiscountPolicySchema
);
