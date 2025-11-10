/**
 * 📘 tuition_enum.dart
 * Enum dùng trong hệ thống học phí (OmniMer EDU)
 * Mỗi enum đều có:
 * - displayName: tên hiển thị thân thiện
 * - asString: lấy giá trị gốc để lưu DB/API
 * - fromString(): parse từ giá trị string
 */

/// Toán tử điều kiện
enum TuitionConditionOperatorEnum {
  eq("Bằng"),
  neq("Khác"),
  gt("Lớn hơn"),
  lt("Nhỏ hơn"),
  gte("Lớn hơn hoặc bằng"),
  lte("Nhỏ hơn hoặc bằng"),
  rin("Nằm trong"),
  nin("Không nằm trong"),
  contains("Chứa");

  final String displayName;
  const TuitionConditionOperatorEnum(this.displayName);

  String get asString => name;

  static TuitionConditionOperatorEnum fromString(String? value) {
    return TuitionConditionOperatorEnum.values.firstWhere(
      (e) => e.name == value,
      orElse: () => TuitionConditionOperatorEnum.eq,
    );
  }
}

/// Kiểu dữ liệu của giá trị điều kiện
enum TuitionConditionValueTypeEnum {
  string("Chuỗi"),
  number("Số"),
  boolean("Đúng/Sai"),
  array("Mảng"),
  object("Đối tượng");

  final String displayName;
  const TuitionConditionValueTypeEnum(this.displayName);

  String get asString => name;

  static TuitionConditionValueTypeEnum fromString(String? value) {
    return TuitionConditionValueTypeEnum.values.firstWhere(
      (e) => e.name == value,
      orElse: () => TuitionConditionValueTypeEnum.string,
    );
  }
}

/// Loại giảm giá
enum DiscountKindEnum {
  percentage("Theo phần trăm"),
  fixed("Cố định");

  final String displayName;
  const DiscountKindEnum(this.displayName);

  String get asString => name;

  static DiscountKindEnum fromString(String? value) {
    return DiscountKindEnum.values.firstWhere(
      (e) => e.name == value,
      orElse: () => DiscountKindEnum.percentage,
    );
  }
}

/// Mục tiêu áp dụng giảm giá
enum DiscountTargetEnum {
  subtotal("Tổng tạm tính"),
  baseFee("Học phí cơ bản"),
  specific_fee("Phụ phí cụ thể");

  final String displayName;
  const DiscountTargetEnum(this.displayName);

  String get asString => name;

  static DiscountTargetEnum fromString(String? value) {
    return DiscountTargetEnum.values.firstWhere(
      (e) => e.name == value,
      orElse: () => DiscountTargetEnum.subtotal,
    );
  }
}

/// Phạm vi áp dụng giảm giá
enum DiscountApplicabilityScopeEnum {
  All("Tất cả"),
  Class("Lớp học"),
  Grade("Khối lớp"),
  Student("Học sinh");

  final String displayName;
  const DiscountApplicabilityScopeEnum(this.displayName);

  String get asString => name;

  static DiscountApplicabilityScopeEnum fromString(String? value) {
    return DiscountApplicabilityScopeEnum.values.firstWhere(
      (e) => e.name == value,
      orElse: () => DiscountApplicabilityScopeEnum.All,
    );
  }
}

/// Chu kỳ áp dụng giảm giá
enum DiscountOncePerEnum {
  month("Theo tháng"),
  term("Theo học kỳ"),
  none("Không giới hạn");

  final String displayName;
  const DiscountOncePerEnum(this.displayName);

  String get asString => name;

  static DiscountOncePerEnum fromString(String? value) {
    return DiscountOncePerEnum.values.firstWhere(
      (e) => e.name == value,
      orElse: () => DiscountOncePerEnum.none,
    );
  }
}

/// Cách tính phụ phí
enum FeeCalcTypeEnum {
  fixed("Cố định"),
  per_session("Theo buổi"),
  per_month("Theo tháng"),
  formula("Theo công thức");

  final String displayName;
  const FeeCalcTypeEnum(this.displayName);

  String get asString => name;

  static FeeCalcTypeEnum fromString(String? value) {
    return FeeCalcTypeEnum.values.firstWhere(
      (e) => e.name == value,
      orElse: () => FeeCalcTypeEnum.fixed,
    );
  }
}

/// Phạm vi áp dụng phụ phí
enum ExtraFeeApplicabilityScopeEnum {
  All("Tất cả"),
  Class("Lớp học"),
  Grade("Khối lớp"),
  Student("Học sinh");

  final String displayName;
  const ExtraFeeApplicabilityScopeEnum(this.displayName);

  String get asString => name;

  static ExtraFeeApplicabilityScopeEnum fromString(String? value) {
    return ExtraFeeApplicabilityScopeEnum.values.firstWhere(
      (e) => e.name == value,
      orElse: () => ExtraFeeApplicabilityScopeEnum.All,
    );
  }
}

/// Chu kỳ áp dụng phụ phí
enum ExtraFeeOncePerEnum {
  month("Theo tháng"),
  term("Theo học kỳ"),
  year("Theo năm"),
  none("Không giới hạn");

  final String displayName;
  const ExtraFeeOncePerEnum(this.displayName);

  String get asString => name;

  static ExtraFeeOncePerEnum fromString(String? value) {
    return ExtraFeeOncePerEnum.values.firstWhere(
      (e) => e.name == value,
      orElse: () => ExtraFeeOncePerEnum.none,
    );
  }
}

/// Loại công thức tính phụ phí
enum ExtraFeeFormulaTypeEnum {
  jsonlogic("JSON Logic"),
  js("JavaScript");

  final String displayName;
  const ExtraFeeFormulaTypeEnum(this.displayName);

  String get asString => name;

  static ExtraFeeFormulaTypeEnum fromString(String? value) {
    return ExtraFeeFormulaTypeEnum.values.firstWhere(
      (e) => e.name == value,
      orElse: () => ExtraFeeFormulaTypeEnum.jsonlogic,
    );
  }
}

/// Trạng thái học phí
enum TuitionStatusEnum {
  draft("Nháp"),
  pending("Chờ thanh toán"),
  paid("Đã thanh toán"),
  cancelled("Đã hủy"),
  failed("Thất bại");

  final String displayName;
  const TuitionStatusEnum(this.displayName);

  String get asString => name;

  static TuitionStatusEnum fromString(String? value) {
    return TuitionStatusEnum.values.firstWhere(
      (e) => e.name == value,
      orElse: () => TuitionStatusEnum.draft,
    );
  }
}

/// Loại tiền tệ
enum CurrencyEnum {
  vnd("Việt Nam Đồng"),
  usd("Đô la Mỹ");

  final String displayName;
  const CurrencyEnum(this.displayName);

  String get asString => name.toUpperCase();

  static CurrencyEnum fromString(String? value) {
    return CurrencyEnum.values.firstWhere(
      (e) => e.name.toUpperCase() == value?.toUpperCase(),
      orElse: () => CurrencyEnum.vnd,
    );
  }
}
