import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:flutter_ios_android_platforms/domain/entities/auth/register_user_entity.dart';

// Events
abstract class RegistrationEvent extends Equatable {
  const RegistrationEvent();

  @override
  List<Object?> get props => [];
}

class LoadRolesEvent extends RegistrationEvent {}

class RegisterUserEvent extends RegistrationEvent {
  final RegisterUserEntity userEntity;
  final File? avatarFile;
  final File? schoolLogoFile;

  const RegisterUserEvent(
    this.userEntity, {
    this.avatarFile,
    this.schoolLogoFile,
  });

  @override
  List<Object?> get props => [userEntity, avatarFile, schoolLogoFile];
}

class SearchSchoolByCodeEvent extends RegistrationEvent {
  final String code;

  const SearchSchoolByCodeEvent(this.code);

  @override
  List<Object?> get props => [code];
}
