/**
 * 📘 tuition.enum.ts
 * Enum và Tuple dùng chung trong module học phí.
 */

/**
 * Các toán tử điều kiện hỗ trợ trong hệ thống học phí.
 */
export enum TuitionConditionOperatorEnum {
  Eq = "eq",
  Neq = "neq",
  Gt = "gt",
  Lt = "lt",
  Gte = "gte",
  Lte = "lte",
  In = "in",
  Nin = "nin",
  Contains = "contains",
}

/**
 * Tuple được sinh từ enum, dùng để gắn enum constraint trong Mongoose Schema.
 */
export const TuitionConditionOperatorTuple = Object.values(
  TuitionConditionOperatorEnum
) as [TuitionConditionOperatorEnum, ...TuitionConditionOperatorEnum[]];

/**
 * Các kiểu dữ liệu cho giá trị so sánh.
 */
export enum TuitionConditionValueTypeEnum {
  String = "string",
  Number = "number",
  Boolean = "boolean",
  Array = "array",
  Object = "object",
}

export const TuitionConditionValueTypeTuple = Object.values(
  TuitionConditionValueTypeEnum
) as [TuitionConditionValueTypeEnum, ...TuitionConditionValueTypeEnum[]];

/**
 * 📘 tuition.enum.ts
 * Enum và Tuple dùng chung cho module học phí (tuition).
 */

/* ============================================================
 * ENUM CHO DISCOUNT POLICY
 * ============================================================
 */

/**
 * Loại giảm giá (theo phần trăm hoặc cố định)
 */
export enum DiscountKindEnum {
  Percentage = "percentage",
  Fixed = "fixed",
}

export const DiscountKindTuple = Object.values(DiscountKindEnum) as [
  DiscountKindEnum,
  ...DiscountKindEnum[]
];

/**
 * Mục tiêu áp dụng giảm giá
 * - subtotal: tổng tạm tính
 * - baseFee: học phí cơ bản
 * - specific_fee: chỉ áp dụng cho một phụ phí cụ thể
 */
export enum DiscountTargetEnum {
  Subtotal = "subtotal",
  BaseFee = "baseFee",
  SpecificFee = "specific_fee",
}

export const DiscountTargetTuple = Object.values(DiscountTargetEnum) as [
  DiscountTargetEnum,
  ...DiscountTargetEnum[]
];

/**
 * Phạm vi áp dụng (scope)
 */
export enum DiscountApplicabilityScopeEnum {
  All = "all",
  Class = "class",
  Grade = "grade",
  Student = "student",
}

export const DiscountApplicabilityScopeTuple = Object.values(
  DiscountApplicabilityScopeEnum
) as [DiscountApplicabilityScopeEnum, ...DiscountApplicabilityScopeEnum[]];

/**
 * Chu kỳ áp dụng (once per)
 */
export enum DiscountOncePerEnum {
  Month = "month",
  Term = "term",
  None = "none", // dùng thay cho null để đồng nhất kiểu
}

export const DiscountOncePerTuple = Object.values(DiscountOncePerEnum) as [
  DiscountOncePerEnum,
  ...DiscountOncePerEnum[]
];

/**
 * 📘 tuition.enum.ts
 * Enum và Tuple dùng chung cho module học phí (Tuition, ExtraFee, DiscountPolicy, Condition).
 */

/* ============================================================
 * EXTRA FEE ENUMS
 * ============================================================
 */

/**
 * Cách tính phụ phí (Extra Fee Calculation Type)
 */
export enum FeeCalcTypeEnum {
  Fixed = "fixed",
  PerSession = "per_session",
  PerMonth = "per_month",
  Formula = "formula",
}

export const FeeCalcTypeTuple = Object.values(FeeCalcTypeEnum) as [
  FeeCalcTypeEnum,
  ...FeeCalcTypeEnum[]
];

/**
 * Phạm vi áp dụng phụ phí (Scope)
 */
export enum ExtraFeeApplicabilityScopeEnum {
  All = "all",
  Class = "class",
  Grade = "grade",
  Student = "student",
}

export const ExtraFeeApplicabilityScopeTuple = Object.values(
  ExtraFeeApplicabilityScopeEnum
) as [ExtraFeeApplicabilityScopeEnum, ...ExtraFeeApplicabilityScopeEnum[]];

/**
 * Chu kỳ áp dụng phụ phí (Once Per Period)
 */
export enum ExtraFeeOncePerEnum {
  Month = "month",
  Term = "term",
  Year = "year",
  None = "none",
}

export const ExtraFeeOncePerTuple = Object.values(ExtraFeeOncePerEnum) as [
  ExtraFeeOncePerEnum,
  ...ExtraFeeOncePerEnum[]
];

/**
 * Loại công thức tính toán (formula type)
 */
export enum ExtraFeeFormulaTypeEnum {
  JsonLogic = "jsonlogic",
  JavaScript = "js",
}

export const ExtraFeeFormulaTypeTuple = Object.values(
  ExtraFeeFormulaTypeEnum
) as [ExtraFeeFormulaTypeEnum, ...ExtraFeeFormulaTypeEnum[]];

/**
 * ============================================================
 * ENUM CHO TUITION CHÍNH
 * ============================================================
 */

/**
 * Trạng thái của học phí (tuition status)
 */
export enum TuitionStatusEnum {
  Draft = "draft",
  Pending = "pending",
  Paid = "paid",
  Cancelled = "cancelled",
  Failed = "failed",
}

export const TuitionStatusTuple = Object.values(TuitionStatusEnum) as [
  TuitionStatusEnum,
  ...TuitionStatusEnum[]
];

/**
 * Loại tiền tệ (currency)
 * → Có thể mở rộng thêm USD, EUR nếu OmniMer EDU có multi-region
 */
export enum CurrencyEnum {
  VND = "VND",
  USD = "USD",
}

export const CurrencyTuple = Object.values(CurrencyEnum) as [
  CurrencyEnum,
  ...CurrencyEnum[]
];
