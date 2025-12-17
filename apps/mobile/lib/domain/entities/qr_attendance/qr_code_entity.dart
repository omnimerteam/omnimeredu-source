import 'package:equatable/equatable.dart';

/// Entity cho QR Code data
class QRCodeEntity extends Equatable {
  final String attendanceId;
  final String qrData;          // Encrypted data to encode in QR
  final DateTime expiry;
  final String? dynamicCode;

  const QRCodeEntity({
    required this.attendanceId,
    required this.qrData,
    required this.expiry,
    this.dynamicCode,
  });

  /// Check if QR code is expired
  bool get isExpired => DateTime.now().isAfter(expiry);

  /// Get remaining time in seconds
  int get remainingSeconds {
    if (isExpired) return 0;
    return expiry.difference(DateTime.now()).inSeconds;
  }

  @override
  List<Object?> get props => [attendanceId, qrData, expiry, dynamicCode];
}

