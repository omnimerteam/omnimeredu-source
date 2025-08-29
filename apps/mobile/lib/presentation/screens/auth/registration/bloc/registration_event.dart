import 'dart:io';
import 'package:equatable/equatable.dart';

abstract class RegistrationEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class RegistrationEmailChanged extends RegistrationEvent {
  final String value;
  RegistrationEmailChanged(this.value);
  @override
  List<Object?> get props => [value];
}

class RegistrationPasswordChanged extends RegistrationEvent {
  final String value;
  RegistrationPasswordChanged(this.value);
  @override
  List<Object?> get props => [value];
}

class RegistrationFullNameChanged extends RegistrationEvent {
  final String value;
  RegistrationFullNameChanged(this.value);
  @override
  List<Object?> get props => [value];
}

class RegistrationRoleIdChanged extends RegistrationEvent {
  final String value;
  RegistrationRoleIdChanged(this.value);
  @override
  List<Object?> get props => [value];
}

class RegistrationGenderChanged extends RegistrationEvent {
  final String value;
  RegistrationGenderChanged(this.value);
  @override
  List<Object?> get props => [value];
}

class RegistrationPhoneChanged extends RegistrationEvent {
  final String? value;
  RegistrationPhoneChanged(this.value);
  @override
  List<Object?> get props => [value];
}

class RegistrationBirthdayChanged extends RegistrationEvent {
  final DateTime? value;
  RegistrationBirthdayChanged(this.value);
  @override
  List<Object?> get props => [value];
}

class RegistrationAddressChanged extends RegistrationEvent {
  final String? value;
  RegistrationAddressChanged(this.value);
  @override
  List<Object?> get props => [value];
}

class RegistrationSchoolIdChanged extends RegistrationEvent {
  final String? value;
  RegistrationSchoolIdChanged(this.value);
  @override
  List<Object?> get props => [value];
}

class RegistrationClassIdChanged extends RegistrationEvent {
  final String? value;
  RegistrationClassIdChanged(this.value);
  @override
  List<Object?> get props => [value];
}

class RegistrationSpecificInfoChanged extends RegistrationEvent {
  final Map<String, dynamic> map;
  RegistrationSpecificInfoChanged(this.map);
  @override
  List<Object?> get props => [map];
}

class RegistrationPickAvatar extends RegistrationEvent {
  final File? file;
  RegistrationPickAvatar(this.file);
  @override
  List<Object?> get props => [file?.path];
}

class RegistrationPickSchoolLogo extends RegistrationEvent {
  final File? file;
  RegistrationPickSchoolLogo(this.file);
  @override
  List<Object?> get props => [file?.path];
}

class RegistrationSubmitted extends RegistrationEvent {}

class RegistrationLoadRoles extends RegistrationEvent {}
