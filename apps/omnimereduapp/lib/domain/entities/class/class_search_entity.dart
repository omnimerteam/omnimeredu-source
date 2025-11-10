import 'package:equatable/equatable.dart';
import '../../../core/constants/enum_constant.dart';

class ClassSearchEntity extends Equatable {
  final String id;
  final String name;
  final String code;
  final String schoolId;
  final String gradeId;
  final EducationGradesEnum gradeGroup;

  const ClassSearchEntity({
    required this.id,
    required this.name,
    required this.code,
    required this.schoolId,
    required this.gradeId,
    required this.gradeGroup,
  });

  @override
  List<Object?> get props => [id, name, code, schoolId, gradeId, gradeGroup];
}
