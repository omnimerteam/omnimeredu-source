import mongoose, { Schema, Document, Types } from "mongoose";
import {
  TuitionStatusEnum,
  TuitionStatusTuple,
  DiscountKindEnum,
  DiscountKindTuple,
  CurrencyEnum,
  CurrencyTuple,
} from "../../../../common/enum/tuition.enum";

/**
 * Snapshot của phụ phí khi tạo học phí
 */
export interface IExtraFeeDetail {
  feeId: Types.ObjectId;
  feeCode?: string;
  feeName?: string;
  unitAmountSnapshot?: number;
  quantity: number;
  calculatedAmount: number;
}

/**
 * Snapshot của giảm giá khi tạo học phí
 */
export interface IDiscountDetail {
  discountId: Types.ObjectId;
  discountCode?: string;
  discountName?: string;
  kind?: DiscountKindEnum;
  valueSnapshot?: number;
  appliedAmount: number;
}

/**
 * Mô hình học phí chính (đã tính hoặc đang chờ xác nhận)
 */
export interface ITuition extends Document {
  _id: Types.ObjectId;
  studentId: Types.ObjectId;
  schoolId: Types.ObjectId;
  classId: Types.ObjectId;

  month?: string; // legacy (cũ)
  periodStart?: Date;
  periodEnd?: Date;

  baseFeeSnapshot: number;
  extraFeeDetails?: IExtraFeeDetail[];
  discountDetails?: IDiscountDetail[];
  appliedRules?: any[];
  calculationLog?: Record<string, any>;

  totalAmount: number;
  attendedDays: number;
  currency: CurrencyEnum;

  status: TuitionStatusEnum;
  createdBy?: Types.ObjectId;
  confirmedBy?: Types.ObjectId;
  confirmedAt?: Date;
  paidAt?: Date;
  invoiceId?: string;
  dueDate?: Date;

  meta?: Record<string, any>;
}

// Subschema cho ExtraFeeDetail
const ExtraFeeDetailSchema = new Schema<IExtraFeeDetail>(
  {
    feeId: { type: Schema.Types.ObjectId, ref: "ExtraFee", required: true },
    feeCode: String,
    feeName: String,
    unitAmountSnapshot: Number,
    quantity: { type: Number, default: 1, min: 0 },
    calculatedAmount: { type: Number, required: true },
  },
  { _id: false }
);

// Subschema cho DiscountDetail
const DiscountDetailSchema = new Schema<IDiscountDetail>(
  {
    discountId: {
      type: Schema.Types.ObjectId,
      ref: "DiscountPolicy",
      required: true,
    },
    discountCode: String,
    discountName: String,
    kind: { type: String, enum: DiscountKindTuple },
    valueSnapshot: Number,
    appliedAmount: { type: Number, required: true },
  },
  { _id: false }
);

const TuitionSchema = new Schema<ITuition>(
  {
    _id: { type: Schema.Types.ObjectId, auto: true },
    studentId: { type: Schema.Types.ObjectId, ref: "BaseUser", required: true },
    schoolId: { type: Schema.Types.ObjectId, ref: "School", required: true },
    classId: { type: Schema.Types.ObjectId, ref: "Class", required: true },

    month: String,
    periodStart: Date,
    periodEnd: Date,

    baseFeeSnapshot: { type: Number, required: true },
    extraFeeDetails: [ExtraFeeDetailSchema],
    discountDetails: [DiscountDetailSchema],
    appliedRules: { type: Schema.Types.Mixed },
    calculationLog: { type: Schema.Types.Mixed },

    totalAmount: { type: Number, required: true },
    attendedDays: { type: Number, default: 0 },
    currency: { type: String, enum: CurrencyTuple, default: CurrencyEnum.VND },

    status: {
      type: String,
      enum: TuitionStatusTuple,
      default: TuitionStatusEnum.Draft,
    },
    createdBy: { type: Schema.Types.ObjectId, ref: "BaseUser" },
    confirmedBy: { type: Schema.Types.ObjectId, ref: "BaseUser" },
    confirmedAt: Date,
    paidAt: Date,
    invoiceId: String,
    dueDate: Date,
    meta: { type: Schema.Types.Mixed, default: {} },
  },
  { timestamps: true }
);

// Đảm bảo mỗi học sinh chỉ có 1 học phí cho mỗi kỳ
TuitionSchema.index(
  { studentId: 1, schoolId: 1, periodStart: 1 },
  { unique: true, sparse: true }
);

export default mongoose.model<ITuition>("Tuition", TuitionSchema);
