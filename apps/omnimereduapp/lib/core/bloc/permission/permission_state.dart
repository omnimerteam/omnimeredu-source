import 'package:equatable/equatable.dart';
import 'package:permission_handler/permission_handler.dart';

abstract class PermissionState extends Equatable {
  const PermissionState();

  @override
  List<Object?> get props => [];
}

class PermissionInitial extends PermissionState {}

class PermissionLoading extends PermissionState {
  final Permission permission;
  const PermissionLoading(this.permission);

  @override
  List<Object?> get props => [permission];
}

class PermissionGranted extends PermissionState {
  final Permission permission;
  const PermissionGranted(this.permission);

  @override
  List<Object?> get props => [permission];
}

class PermissionDenied extends PermissionState {
  final Permission permission;
  const PermissionDenied(this.permission);

  @override
  List<Object?> get props => [permission];
}

class PermissionPermanentlyDenied extends PermissionState {
  final Permission permission;
  const PermissionPermanentlyDenied(this.permission);

  @override
  List<Object?> get props => [permission];
}

class PermissionRestricted extends PermissionState {
  final Permission permission;
  const PermissionRestricted(this.permission);

  @override
  List<Object?> get props => [permission];
}
