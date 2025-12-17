import 'package:equatable/equatable.dart';

abstract class QRDisplayEvent extends Equatable {
  const QRDisplayEvent();

  @override
  List<Object?> get props => [];
}

class GenerateQRCodeEvent extends QRDisplayEvent {
  final String attendanceId;

  const GenerateQRCodeEvent(this.attendanceId);

  @override
  List<Object?> get props => [attendanceId];
}

class RefreshQRCodeEvent extends QRDisplayEvent {
  final String attendanceId;

  const RefreshQRCodeEvent(this.attendanceId);

  @override
  List<Object?> get props => [attendanceId];
}

class DisposeQRDisplayEvent extends QRDisplayEvent {
  const DisposeQRDisplayEvent();
}

class TickEvent extends QRDisplayEvent {
  final int remainingSeconds;
  const TickEvent(this.remainingSeconds);
  @override
  List<Object?> get props => [remainingSeconds];
}
