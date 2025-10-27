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
  String = "String",
  Number = "Number",
  Boolean = "Boolean",
  Array = "Array",
  Object = "Object",
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
  Percentage = "Percentage",
  Fixed = "Fixed",
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
  Subtotal = "Subtotal",
  BaseFee = "BaseFee",
  SpecificFee = "SpecificFee",
}

export const DiscountTargetTuple = Object.values(DiscountTargetEnum) as [
  DiscountTargetEnum,
  ...DiscountTargetEnum[]
];

/**
 * Phạm vi áp dụng (scope)
 */
export enum DiscountApplicabilityScopeEnum {
  All = "All",
  Class = "Class",
  Grade = "Grade",
  Student = "Student",
}

export const DiscountApplicabilityScopeTuple = Object.values(
  DiscountApplicabilityScopeEnum
) as [DiscountApplicabilityScopeEnum, ...DiscountApplicabilityScopeEnum[]];

/**
 * Chu kỳ áp dụng (once per)
 */
export enum DiscountOncePerEnum {
  Month = "Month",
  Term = "Term",
  None = "None", // dùng thay cho null để đồng nhất kiểu
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
  Fixed = "Fixed",
  PerSession = "PerSession",
  PerMonth = "PerMonth",
  PerYear = "PerYear",
}

export const FeeCalcTypeTuple = Object.values(FeeCalcTypeEnum) as [
  FeeCalcTypeEnum,
  ...FeeCalcTypeEnum[]
];

/**
 * Phạm vi áp dụng phụ phí (Scope)
 */
export enum ExtraFeeApplicabilityScopeEnum {
  All = "All",
  Class = "Class",
  Grade = "Grade",
  Student = "Student",
}

export const ExtraFeeApplicabilityScopeTuple = Object.values(
  ExtraFeeApplicabilityScopeEnum
) as [ExtraFeeApplicabilityScopeEnum, ...ExtraFeeApplicabilityScopeEnum[]];

/**
 * Chu kỳ áp dụng phụ phí (Once Per Period)
 */
export enum ExtraFeeOncePerEnum {
  Month = "Month",
  Term = "Term",
  Year = "Year",
  None = "None",
}

export const ExtraFeeOncePerTuple = Object.values(ExtraFeeOncePerEnum) as [
  ExtraFeeOncePerEnum,
  ...ExtraFeeOncePerEnum[]
];

/**
 * ============================================================
 * ENUM CHO TUITION CHÍNH
 * ============================================================
 */

/**
 * Trạng thái của học phí (tuition status)
 */
export enum TuitionStatusEnum {
  Draft = "Draft",
  Pending = "Pending",
  Paid = "Paid",
  Cancelled = "Cancelled",
  Failed = "Failed",
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
