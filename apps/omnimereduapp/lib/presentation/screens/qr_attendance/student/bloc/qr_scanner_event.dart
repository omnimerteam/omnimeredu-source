import 'package:equatable/equatable.dart';

/// Events cho QR Scanner BLoC
abstract class QRScannerEvent extends Equatable {
  const QRScannerEvent();

  @override
  List<Object?> get props => [];
}

/// Event khi screen được khởi tạo
class InitializeScannerEvent extends QRScannerEvent {
  const InitializeScannerEvent();
}

/// Event khi quét được QR code
class QRCodeScannedEvent extends QRScannerEvent {
  final String qrData;

  const QRCodeScannedEvent(this.qrData);

  @override
  List<Object?> get props => [qrData];
}

/// Event reset scanner để quét lại
class ResetScannerEvent extends QRScannerEvent {
  const ResetScannerEvent();
}

/// Event kiểm tra và sync offline scans
class CheckOfflineSyncsEvent extends QRScannerEvent {
  const CheckOfflineSyncsEvent();
}

/// Event dispose resources
class DisposeScannerEvent extends QRScannerEvent {
  const DisposeScannerEvent();
}

