import 'package:equatable/equatable.dart';
import '../../../../../domain/entities/qr_attendance/qr_code_entity.dart';

/// States cho QR Display BLoC
abstract class QRDisplayState extends Equatable {
  const QRDisplayState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class QRDisplayInitial extends QRDisplayState {
  const QRDisplayInitial();
}

/// Loading state
class QRDisplayLoading extends QRDisplayState {
  const QRDisplayLoading();
}

/// Success state - QR code generated
class QRDisplaySuccess extends QRDisplayState {
  final QRCodeEntity qrCode;
  final int remainingSeconds;

  const QRDisplaySuccess({
    required this.qrCode,
    required this.remainingSeconds,
  });

  @override
  List<Object?> get props => [qrCode, remainingSeconds];

  bool get isExpired => remainingSeconds <= 0;
}

/// Expired state
class QRDisplayExpired extends QRDisplayState {
  final QRCodeEntity qrCode;

  const QRDisplayExpired(this.qrCode);

  @override
  List<Object?> get props => [qrCode];
}

/// Error state
class QRDisplayError extends QRDisplayState {
  final String message;

  const QRDisplayError(this.message);

  @override
  List<Object?> get props => [message];
}

