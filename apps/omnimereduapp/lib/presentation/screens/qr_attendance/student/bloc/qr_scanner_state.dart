import 'package:equatable/equatable.dart';
import '../../../../../domain/entities/qr_attendance/scan_result_entity.dart';

/// States cho QR Scanner BLoC
abstract class QRScannerState extends Equatable {
  const QRScannerState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class QRScannerInitial extends QRScannerState {
  const QRScannerInitial();
}

/// Ready to scan state
class QRScannerReady extends QRScannerState {
  final bool isOnline;
  final int pendingOfflineScans;

  const QRScannerReady({
    this.isOnline = true,
    this.pendingOfflineScans = 0,
  });

  @override
  List<Object?> get props => [isOnline, pendingOfflineScans];
}

/// Scanning state - đang xử lý QR
class QRScannerScanning extends QRScannerState {
  const QRScannerScanning();
}

/// Success state - quét thành công
class QRScannerSuccess extends QRScannerState {
  final ScanResultEntity result;

  const QRScannerSuccess(this.result);

  @override
  List<Object?> get props => [result];
}

/// Error state
class QRScannerError extends QRScannerState {
  final String message;

  const QRScannerError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Permission denied state
class QRScannerPermissionDenied extends QRScannerState {
  final String message;

  const QRScannerPermissionDenied(this.message);

  @override
  List<Object?> get props => [message];
}

