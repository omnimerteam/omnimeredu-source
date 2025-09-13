import 'package:equatable/equatable.dart';
import 'package:flutter_ios_android_platforms/domain/entities/school/school_data_entity.dart';

abstract class SchoolDataAdminState extends Equatable {
  const SchoolDataAdminState();

  @override
  List<Object?> get props => [];
}

class SchoolDataAdminInitial extends SchoolDataAdminState {}

class SchoolDataAdminLoading extends SchoolDataAdminState {}

class SchoolDataAdminLoaded extends SchoolDataAdminState {
  final SchoolDataEntity school;

  const SchoolDataAdminLoaded(this.school);

  @override
  List<Object?> get props => [school];
}

class SchoolDataAdminEmpty extends SchoolDataAdminState {} // chưa có trường

class SchoolDataAdminError extends SchoolDataAdminState {
  final String message;

  const SchoolDataAdminError(this.message);

  @override
  List<Object?> get props => [message];
}
