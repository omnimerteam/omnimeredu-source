import 'package:equatable/equatable.dart';

class ClassEntity extends Equatable {
  final String? id;
  final String? name;
  final String? code;
  final String? schoolId;
  final int? maxStudents;
  final int? baseFee;

  const ClassEntity({
    this.id,
    this.name,
    this.code,
    this.schoolId,
    this.maxStudents,
    this.baseFee,
  });

  @override
  List<Object?> get props => [id, name, code, schoolId, maxStudents, baseFee];
}
