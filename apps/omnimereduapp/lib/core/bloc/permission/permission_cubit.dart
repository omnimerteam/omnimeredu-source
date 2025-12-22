import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:permission_handler/permission_handler.dart';
import 'permission_state.dart';

class PermissionCubit extends Cubit<PermissionState> {
  PermissionCubit() : super(PermissionInitial());

  /// Request a specific permission
  Future<void> requestPermission(Permission permission) async {
    emit(PermissionLoading(permission));
    final status = await permission.request();

    _emitPermissionStatus(permission, status);
  }

  /// Check current status without requesting
  Future<void> checkPermission(Permission permission) async {
    final status = await permission.status;
    _emitPermissionStatus(permission, status);
  }

  /// Open app settings
  Future<bool> openSettings() async {
    return await openAppSettings();
  }

  void _emitPermissionStatus(Permission permission, PermissionStatus status) {
    switch (status) {
      case PermissionStatus.granted:
        emit(PermissionGranted(permission));
        break;
      case PermissionStatus.denied:
        emit(PermissionDenied(permission));
        break;
      case PermissionStatus.permanentlyDenied:
        emit(PermissionPermanentlyDenied(permission));
        break;
      case PermissionStatus.restricted:
        emit(PermissionRestricted(permission));
        break;
      case PermissionStatus.limited:
      case PermissionStatus.provisional:
        // Treat limited/provisional as granted for basic usage or standard
        emit(PermissionGranted(permission));
        break;
    }
  }
}
