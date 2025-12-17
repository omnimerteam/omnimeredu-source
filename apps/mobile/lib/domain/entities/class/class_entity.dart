import 'package:equatable/equatable.dart';
import '../../../core/constants/enum_constant.dart';

class ClassEntity extends Equatable {
  final String id;
  final String name;
  final String? code;
  final String schoolId;
  final String gradeId;
  final int? maxStudents;
  final int currentStudents;
  final num baseFee;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ClassEntity({
    required this.id,
    required this.name,
    this.code,
    required this.schoolId,
    required this.gradeId,
    this.maxStudents,
    required this.currentStudents,
    required this.baseFee,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    code,
    schoolId,
    gradeId,
    maxStudents,
    currentStudents,
    baseFee,
    createdAt,
    updatedAt,
  ];
}
