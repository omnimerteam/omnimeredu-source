import 'package:flutter_ios_android_platforms/core/constants/app_constant.dart';
import 'package:flutter_ios_android_platforms/core/constants/tuition_enum.dart';
import 'package:flutter_ios_android_platforms/data/models/tuition/tuition_condition_model.dart';
import 'package:flutter_ios_android_platforms/domain/entities/tuition/extra_fee_entity.dart';

/// 🔹 ExtraFeeModel - mapping JSON <-> Entity
class ExtraFeeModel {
  final String? id;
  final String? code;
  final String name;
  final String? description;
  final FeeCalcTypeEnum calcType;
  final double unitAmount;
  final String? unitName;
  final List<ConditionModel>? conditions;
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

  const ExtraFeeModel({
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

  factory ExtraFeeModel.fromJson(Map<String, dynamic> json) {
    return ExtraFeeModel(
      id: json['_id'],
      code: json['code'],
      name: json['name'],
      description: json['description'],
      calcType: FeeCalcTypeEnum.fromString(json['calcType']),
      unitAmount: (json['unitAmount'] ?? 0).toDouble(),
      unitName: json['unitName'],
      conditions: (json['conditions'] as List?)
          ?.map((e) => ConditionModel.fromJson(e))
          .toList(),
      schoolId: json['schoolId'] as String,
      applicableScope: ExtraFeeApplicabilityScopeEnum.fromString(
        json['applicableScope'],
      ),
      applicableClassIds: (json['applicableClassIds'] as List?)?.cast<String>(),
      applicableGradeIds: (json['applicableGradeIds'] as List?)?.cast<String>(),
      applicableStudentIds: (json['applicableStudentIds'] as List?)
          ?.cast<String>(),
      oncePer: ExtraFeeOncePerEnum.fromString(json['oncePer']),
      priority: json['priority'] as int?,
      active: json['active'] as bool?,
      effectiveFrom: (json['effectiveFrom'] as String?) != null
          ? AppConstants.toVietnamTime(DateTime.parse(json['effectiveFrom']))
          : null,
      effectiveTo: (json['effectiveTo'] as String?) != null
          ? AppConstants.toVietnamTime(DateTime.parse(json['effectiveTo']))
          : null,
      formula: json['formula'],
      formulaType: ExtraFeeFormulaTypeEnum.fromString(json['formulaType']),
      isTaxable: json['isTaxable'] as bool?,
      taxRate: (json['taxRate'] ?? 0).toDouble(),
      createdAt: (json['createdAt'] as String?) != null
          ? AppConstants.toVietnamTime(DateTime.parse(json['createdAt']))
          : null,
      updatedAt: (json['updatedAt'] as String?) != null
          ? AppConstants.toVietnamTime(DateTime.parse(json['updatedAt']))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'code': code,
      'name': name,
      'description': description,
      'calcType': calcType.name,
      'unitAmount': unitAmount,
      'unitName': unitName,
      'conditions': conditions?.map((e) => e.toJson()).toList(),
      'schoolId': schoolId,
      'applicableScope': applicableScope?.name,
      'applicableClassIds': applicableClassIds,
      'applicableGradeIds': applicableGradeIds,
      'applicableStudentIds': applicableStudentIds,
      'oncePer': oncePer?.name,
      'priority': priority,
      'active': active,
      'effectiveFrom': effectiveFrom?.toUtc().toIso8601String(),
      'effectiveTo': effectiveTo?.toUtc().toIso8601String(),
      'formula': formula,
      'formulaType': formulaType?.name,
      'isTaxable': isTaxable,
      'taxRate': taxRate,
    };
  }

  factory ExtraFeeModel.fromEntity(ExtraFeeEntity entity) {
    return ExtraFeeModel(
      id: entity.id,
      code: entity.code,
      name: entity.name,
      description: entity.description,
      calcType: entity.calcType,
      unitAmount: entity.unitAmount,
      unitName: entity.unitName,
      conditions: entity.conditions
          ?.map((e) => ConditionModel.fromEntity(e))
          .toList(),
      schoolId: entity.schoolId,
      applicableScope: entity.applicableScope,
      applicableClassIds: entity.applicableClassIds,
      applicableGradeIds: entity.applicableGradeIds,
      applicableStudentIds: entity.applicableStudentIds,
      oncePer: entity.oncePer,
      priority: entity.priority,
      active: entity.active,
      effectiveFrom: entity.effectiveFrom,
      effectiveTo: entity.effectiveTo,
      formula: entity.formula,
      formulaType: entity.formulaType,
      isTaxable: entity.isTaxable,
      taxRate: entity.taxRate,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  ExtraFeeEntity toEntity() {
    return ExtraFeeEntity(
      id: id,
      code: code,
      name: name,
      description: description,
      calcType: calcType,
      unitAmount: unitAmount,
      unitName: unitName,
      conditions: conditions?.map((e) => e.toEntity()).toList(),
      schoolId: schoolId,
      applicableScope: applicableScope,
      applicableClassIds: applicableClassIds,
      applicableGradeIds: applicableGradeIds,
      applicableStudentIds: applicableStudentIds,
      oncePer: oncePer,
      priority: priority,
      active: active,
      effectiveFrom: effectiveFrom,
      effectiveTo: effectiveTo,
      formula: formula,
      formulaType: formulaType,
      isTaxable: isTaxable,
      taxRate: taxRate,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
