import 'package:flutter_ios_android_platforms/core/constants/tuition_enum.dart';
import 'package:flutter_ios_android_platforms/data/models/tuition/tuition_condition_model.dart';
import 'package:flutter_ios_android_platforms/domain/entities/tuition/discount_policy_entity.dart';

/// Model đại diện cho chính sách giảm giá trong tầng data (không kế thừa entity)
class DiscountPolicyModel {
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
  final List<ConditionModel>? conditions;
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

  const DiscountPolicyModel({
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

  // ---------------------------------------------------------------------------
  // 🧭 JSON CONVERSION
  // ---------------------------------------------------------------------------

  /// Parse từ JSON trả về từ API
  factory DiscountPolicyModel.fromJson(Map<String, dynamic> json) {
    return DiscountPolicyModel(
      id: json['_id'] ?? '',
      code: json['code'],
      name: json['name'] ?? '',
      description: json['description'],
      kind: DiscountKindEnum.fromString(json['kind']),
      value: (json['value'] ?? 0).toDouble(),
      target: DiscountTargetEnum.fromString(json['target']),
      targetFeeCode: json['targetFeeCode'],
      maxCap: json['maxCap']?.toDouble(),
      stackable: json['stackable'] ?? false,
      priority: json['priority'] ?? 0,
      exclusiveGroup: json['exclusiveGroup'],
      oncePer: DiscountOncePerEnum.fromString(json['oncePer']),
      conditions: (json['conditions'] as List?)
          ?.map((c) => ConditionModel.fromJson(c))
          .toList(),
      applicabilityScope: DiscountApplicabilityScopeEnum.fromString(
        json['applicabilityScope'],
      ),
      applicableClassIds: (json['applicableClassIds'] as List?)
          ?.map((e) => e.toString())
          .toList(),
      applicableStudentIds: (json['applicableStudentIds'] as List?)
          ?.map((e) => e.toString())
          .toList(),
      applicableGradeIds: (json['applicableGradeIds'] as List?)
          ?.map((e) => e.toString())
          .toList(),
      schoolId: json['schoolId'] ?? '',
      active: json['active'] ?? true,
      effectiveFrom: json['effectiveFrom'] != null
          ? DateTime.tryParse(json['effectiveFrom'])
          : null,
      effectiveTo: json['effectiveTo'] != null
          ? DateTime.tryParse(json['effectiveTo'])
          : null,
      minSubtotal: json['minSubtotal']?.toDouble(),
      maxSubtotal: json['maxSubtotal']?.toDouble(),
    );
  }

  /// Convert sang JSON để gửi API
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'code': code,
      'name': name,
      'description': description,
      'kind': kind.asString,
      'value': value,
      'target': target.asString,
      'targetFeeCode': targetFeeCode,
      'maxCap': maxCap,
      'stackable': stackable,
      'priority': priority,
      'exclusiveGroup': exclusiveGroup,
      'oncePer': oncePer.asString,
      'conditions': conditions?.map((c) => c.toJson()).toList(),
      'applicabilityScope': applicabilityScope.asString,
      'applicableClassIds': applicableClassIds,
      'applicableStudentIds': applicableStudentIds,
      'applicableGradeIds': applicableGradeIds,
      'schoolId': schoolId,
      'active': active,
      'effectiveFrom': effectiveFrom?.toIso8601String(),
      'effectiveTo': effectiveTo?.toIso8601String(),
      'minSubtotal': minSubtotal,
      'maxSubtotal': maxSubtotal,
    };
  }

  // ---------------------------------------------------------------------------
  // 🧩 ENTITY CONVERSION
  // ---------------------------------------------------------------------------

  /// Chuyển từ [DiscountPolicyEntity] sang [DiscountPolicyModel]
  factory DiscountPolicyModel.fromEntity(DiscountPolicyEntity entity) {
    return DiscountPolicyModel(
      id: entity.id,
      code: entity.code,
      name: entity.name,
      description: entity.description,
      kind: entity.kind,
      value: entity.value,
      target: entity.target,
      targetFeeCode: entity.targetFeeCode,
      maxCap: entity.maxCap,
      stackable: entity.stackable,
      priority: entity.priority,
      exclusiveGroup: entity.exclusiveGroup,
      oncePer: entity.oncePer,
      conditions: entity.conditions
          ?.map((e) => ConditionModel.fromEntity(e))
          .toList(),
      applicabilityScope: entity.applicabilityScope,
      applicableClassIds: entity.applicableClassIds,
      applicableStudentIds: entity.applicableStudentIds,
      applicableGradeIds: entity.applicableGradeIds,
      schoolId: entity.schoolId,
      active: entity.active,
      effectiveFrom: entity.effectiveFrom,
      effectiveTo: entity.effectiveTo,
      minSubtotal: entity.minSubtotal,
      maxSubtotal: entity.maxSubtotal,
    );
  }

  /// Chuyển từ [DiscountPolicyModel] sang [DiscountPolicyEntity]
  DiscountPolicyEntity toEntity() {
    return DiscountPolicyEntity(
      id: id,
      code: code,
      name: name,
      description: description,
      kind: kind,
      value: value,
      target: target,
      targetFeeCode: targetFeeCode,
      maxCap: maxCap,
      stackable: stackable,
      priority: priority,
      exclusiveGroup: exclusiveGroup,
      oncePer: oncePer,
      conditions: conditions?.map((e) => e.toEntity()).toList(),
      applicabilityScope: applicabilityScope,
      applicableClassIds: applicableClassIds,
      applicableStudentIds: applicableStudentIds,
      applicableGradeIds: applicableGradeIds,
      schoolId: schoolId,
      active: active,
      effectiveFrom: effectiveFrom,
      effectiveTo: effectiveTo,
      minSubtotal: minSubtotal,
      maxSubtotal: maxSubtotal,
    );
  }
}
