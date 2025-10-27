import '../../../core/constants/tuition_enum.dart';

/// 🔹 Entity đại diện cho một điều kiện áp dụng ExtraFee hoặc DiscountPolicy
class ConditionEntity {
  final String field;
  final TuitionConditionOperatorEnum operator;
  final dynamic value;
  final bool negate;
  final TuitionConditionValueTypeEnum? valueType;

  const ConditionEntity({
    required this.field,
    required this.operator,
    required this.value,
    this.negate = false,
    this.valueType,
  });
}
