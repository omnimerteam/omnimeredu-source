import 'package:equatable/equatable.dart';

class ClassSearchEntity extends Equatable {
  final String id;
  final String name;
  final String code;
  final String schoolId;

  const ClassSearchEntity({
    required this.id,
    required this.name,
    required this.code,
    required this.schoolId,
  });

  @override
  List<Object?> get props => [id, name, code, schoolId];
}
