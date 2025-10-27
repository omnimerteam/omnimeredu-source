import '../../../core/constants/tuition_enum.dart';
import '../../../domain/entities/tuition/tuition_condition_entity.dart';

/// 🔹 ConditionModel - mapping JSON <-> Entity
class ConditionModel {
  final String field;
  final TuitionConditionOperatorEnum operator;
  final dynamic value;
  final bool negate;
  final TuitionConditionValueTypeEnum? valueType;

  const ConditionModel({
    required this.field,
    required this.operator,
    required this.value,
    this.negate = false,
    this.valueType,
  });

  factory ConditionModel.fromJson(Map<String, dynamic> json) {
    return ConditionModel(
      field: json['field'] as String,
      operator: TuitionConditionOperatorEnum.fromString(json['operator']),
      value: json['value'],
      negate: json['negate'] ?? false,
      valueType: TuitionConditionValueTypeEnum.fromString(json['valueType']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'field': field,
      'operator': operator.name,
      'value': value,
      'negate': negate,
      'valueType': valueType?.name,
    };
  }

  factory ConditionModel.fromEntity(ConditionEntity entity) {
    return ConditionModel(
      field: entity.field,
      operator: entity.operator,
      value: entity.value,
      negate: entity.negate,
      valueType: entity.valueType,
    );
  }

  ConditionEntity toEntity() {
    return ConditionEntity(
      field: field,
      operator: operator,
      value: value,
      negate: negate,
      valueType: valueType,
    );
  }
}
