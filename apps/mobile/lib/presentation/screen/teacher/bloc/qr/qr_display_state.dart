import 'package:equatable/equatable.dart';
import '../../../../../domain/entities/qr_attendance/qr_code_entity.dart';

abstract class QRDisplayState extends Equatable {
  const QRDisplayState();

  @override
  List<Object?> get props => [];
}

class QRDisplayInitial extends QRDisplayState {}

class QRDisplayLoading extends QRDisplayState {}

class QRDisplaySuccess extends QRDisplayState {
  final QRCodeEntity qrCode;
  final int remainingSeconds;
  final bool isExpired;

  const QRDisplaySuccess({
    required this.qrCode,
    required this.remainingSeconds,
    this.isExpired = false,
  });

  QRDisplaySuccess copyWith({
    QRCodeEntity? qrCode,
    int? remainingSeconds,
    bool? isExpired,
  }) {
    return QRDisplaySuccess(
      qrCode: qrCode ?? this.qrCode,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      isExpired: isExpired ?? this.isExpired,
    );
  }

  @override
  List<Object?> get props => [qrCode, remainingSeconds, isExpired];
}

class QRDisplayExpired extends QRDisplayState {}

class QRDisplayError extends QRDisplayState {
  final String message;

  const QRDisplayError(this.message);

  @override
  List<Object?> get props => [message];
}
