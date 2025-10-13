import 'package:flutter_ios_android_platforms/core/constants/tuition_enum.dart';
import 'package:flutter_ios_android_platforms/domain/entities/tuition/tuition_condition_entity.dart';

/// 🔹 Entity đại diện cho mô hình phụ phí (Extra Fee)
class ExtraFeeEntity {
  final String? id;
  final String? code;
  final String name;
  final String? description;
  final FeeCalcTypeEnum calcType;
  final double unitAmount;
  final String? unitName;
  final List<ConditionEntity>? conditions;
  final String schoolId;

  final ExtraFeeApplicabilityScopeEnum? applicableScope;
  final List<String>? applicableClassIds;
  final List<String>? applicableGradeIds;
  final List<String>? applicableStudentIds;

  final ExtraFeeOncePerEnum? oncePer;
  final int? priority;
  final bool? active;
  final DateTime? effectiveFrom;
  final DateTime? effectiveTo;

  final dynamic formula;
  final ExtraFeeFormulaTypeEnum? formulaType;

  final bool? isTaxable;
  final double? taxRate;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ExtraFeeEntity({
    this.id,
    this.code,
    required this.name,
    this.description,
    required this.calcType,
    required this.unitAmount,
    this.unitName,
    this.conditions,
    required this.schoolId,
    this.applicableScope,
    this.applicableClassIds,
    this.applicableGradeIds,
    this.applicableStudentIds,
    this.oncePer,
    this.priority,
    this.active,
    this.effectiveFrom,
    this.effectiveTo,
    this.formula,
    this.formulaType,
    this.isTaxable,
    this.taxRate,
    this.createdAt,
    this.updatedAt,
  });
}
