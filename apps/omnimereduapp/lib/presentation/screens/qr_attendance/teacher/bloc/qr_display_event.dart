import 'package:equatable/equatable.dart';

/// Events cho QR Display BLoC
abstract class QRDisplayEvent extends Equatable {
  const QRDisplayEvent();

  @override
  List<Object?> get props => [];
}

/// Event để generate QR code
class GenerateQRCodeEvent extends QRDisplayEvent {
  final String attendanceId;

  const GenerateQRCodeEvent(this.attendanceId);

  @override
  List<Object?> get props => [attendanceId];
}

/// Event để refresh QR code (tạo mã mới)
class RefreshQRCodeEvent extends QRDisplayEvent {
  final String attendanceId;

  const RefreshQRCodeEvent(this.attendanceId);

  @override
  List<Object?> get props => [attendanceId];
}

/// Event khi QR code expire
class QRCodeExpiredEvent extends QRDisplayEvent {
  const QRCodeExpiredEvent();
}

/// Event để dispose resources (brightness, etc.)
class DisposeQRDisplayEvent extends QRDisplayEvent {
  const DisposeQRDisplayEvent();
}

/// Event để update countdown timer
class UpdateQRCountdownEvent extends QRDisplayEvent {
  final int remainingSeconds;

  const UpdateQRCountdownEvent({required this.remainingSeconds});

  @override
  List<Object?> get props => [remainingSeconds];
}

