import 'package:equatable/equatable.dart';
import '../../../../../domain/entities/school/school_data_entity.dart';

abstract class SchoolEvent extends Equatable {
  const SchoolEvent();

  @override
  List<Object?> get props => [];
}

class LoadSchoolDetail extends SchoolEvent {}

class CreateSchool extends SchoolEvent {
  final SchoolDataEntity school;

  const CreateSchool(this.school);

  @override
  List<Object?> get props => [school];
}

class UpdateSchool extends SchoolEvent {
  final SchoolDataEntity school;

  const UpdateSchool(this.school);

  @override
  List<Object?> get props => [school];
}

class DeleteSchool extends SchoolEvent {}
