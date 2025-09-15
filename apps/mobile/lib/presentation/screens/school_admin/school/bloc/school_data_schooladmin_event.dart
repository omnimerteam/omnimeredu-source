import 'package:equatable/equatable.dart';
import 'package:flutter_ios_android_platforms/domain/entities/school/school_data_entity.dart';

abstract class SchoolDataAdminEvent extends Equatable {
  const SchoolDataAdminEvent();

  @override
  List<Object?> get props => [];
}

class LoadSchoolDataAdmin extends SchoolDataAdminEvent {}

class CreateSchoolDataAdminEvent extends SchoolDataAdminEvent {
  final SchoolDataEntity school;

  const CreateSchoolDataAdminEvent(this.school);

  @override
  List<Object?> get props => [school];
}

class UpdateSchoolDataAdminEvent extends SchoolDataAdminEvent {
  final SchoolDataEntity school;

  const UpdateSchoolDataAdminEvent(this.school);

  @override
  List<Object?> get props => [school];
}

class DeleteSchoolDataAdminEvent extends SchoolDataAdminEvent {}
