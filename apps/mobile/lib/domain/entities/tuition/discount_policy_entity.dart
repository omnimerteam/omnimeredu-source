import 'package:equatable/equatable.dart';
import 'package:flutter_ios_android_platforms/core/constants/tuition_enum.dart';
import 'package:flutter_ios_android_platforms/domain/entities/tuition/tuition_condition_entity.dart';

class DiscountPolicyEntity extends Equatable {
  final String? id;

  final String? code;
  final String name;
  final String? description;

  final DiscountKindEnum kind;
  final double value;

  final DiscountTargetEnum target;
  final String? targetFeeCode;
  final double? maxCap;

  final bool stackable;
  final int priority;
  final String? exclusiveGroup;
  final DiscountOncePerEnum oncePer;

  final List<ConditionEntity>? conditions;

  final DiscountApplicabilityScopeEnum applicabilityScope;
  final List<String>? applicableClassIds;
  final List<String>? applicableStudentIds;
  final List<String>? applicableGradeIds;

  final String schoolId;
  final bool active;
  final DateTime? effectiveFrom;
  final DateTime? effectiveTo;

  final double? minSubtotal;
  final double? maxSubtotal;

  const DiscountPolicyEntity({
    this.id,
    this.code,
    required this.name,
    this.description,
    required this.kind,
    required this.value,
    required this.target,
    this.targetFeeCode,
    this.maxCap,
    this.stackable = false,
    this.priority = 0,
    this.exclusiveGroup,
    this.oncePer = DiscountOncePerEnum.none,
    this.conditions,
    this.applicabilityScope = DiscountApplicabilityScopeEnum.all,
    this.applicableClassIds,
    this.applicableStudentIds,
    this.applicableGradeIds,
    required this.schoolId,
    this.active = true,
    this.effectiveFrom,
    this.effectiveTo,
    this.minSubtotal,
    this.maxSubtotal,
  });

  @override
  List<Object?> get props => [
    id,
    code,
    name,
    description,
    kind,
    value,
    target,
    targetFeeCode,
    maxCap,
    stackable,
    priority,
    exclusiveGroup,
    oncePer,
    conditions,
    applicabilityScope,
    applicableClassIds,
    applicableStudentIds,
    applicableGradeIds,
    schoolId,
    active,
    effectiveFrom,
    effectiveTo,
    minSubtotal,
    maxSubtotal,
  ];
}
