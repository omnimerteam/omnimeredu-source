import mongoose, { Schema, Document, Types } from "mongoose";
import { ConditionSchema, ICondition } from "./Condition";
import {
  FeeCalcTypeEnum,
  FeeCalcTypeTuple,
  ExtraFeeApplicabilityScopeEnum,
  ExtraFeeApplicabilityScopeTuple,
  ExtraFeeOncePerEnum,
  ExtraFeeOncePerTuple,
} from "../../../../common/enum/tuition.enum";

/**
 * Interface đại diện cho mô hình phụ phí (Extra Fee)
 */
export interface IExtraFee extends Document {
  _id: Types.ObjectId;

  code?: string;
  name: string;
  description?: string;

  calcType: FeeCalcTypeEnum;
  unitAmount: number;
  unitName?: string;
  conditions?: ICondition[];
  schoolId: Types.ObjectId;

  applicableScope?: ExtraFeeApplicabilityScopeEnum;
  applicableClassIds?: Types.ObjectId[];
  applicableGradeIds?: Types.ObjectId[];
  applicableStudentIds?: Types.ObjectId[];

  oncePer?: ExtraFeeOncePerEnum;
  priority?: number;
  active?: boolean;
  effectiveFrom?: Date;
  effectiveTo?: Date | null;

  isTaxable?: boolean;
  taxRate?: number;
}

/**
 * Schema định nghĩa cho ExtraFee
 */
const ExtraFeeSchema = new Schema<IExtraFee>(
  {
    _id: { type: Schema.Types.ObjectId, auto: true },

    code: { type: String, index: true, unique: true, sparse: true },
    name: { type: String, required: true },
    description: String,

    calcType: {
      type: String,
      enum: FeeCalcTypeTuple,
      required: true,
    },
    unitAmount: { type: Number, default: 0, min: 0 },

    conditions: [ConditionSchema],

    schoolId: {
      type: Schema.Types.ObjectId,
      ref: "School",
      required: true,
      index: true,
    },

    applicableScope: {
      type: String,
      enum: ExtraFeeApplicabilityScopeTuple,
      default: ExtraFeeApplicabilityScopeEnum.All,
    },
    applicableClassIds: [{ type: Schema.Types.ObjectId, ref: "Class" }],
    applicableGradeIds: [{ type: Schema.Types.ObjectId, ref: "Grade" }],
    applicableStudentIds: [{ type: Schema.Types.ObjectId, ref: "BaseUser" }],

    oncePer: {
      type: String,
      enum: ExtraFeeOncePerTuple,
      default: ExtraFeeOncePerEnum.None,
    },
    priority: { type: Number, default: 0 },
    active: { type: Boolean, default: true },
    effectiveFrom: { type: Date, default: Date.now },
    effectiveTo: { type: Date, default: null },

    isTaxable: { type: Boolean, default: false },
    taxRate: { type: Number, default: 0 },
  },
  { timestamps: true }
);

export default mongoose.model<IExtraFee>("ExtraFee", ExtraFeeSchema);
