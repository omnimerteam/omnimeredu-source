import 'package:equatable/equatable.dart';

/// Trạng thái kết quả quét QR
enum ScanStatus {
  success,          // Điểm danh thành công
  expired,          // QR đã hết hạn
  outOfRange,       // Ngoài phạm vi cho phép
  invalidQR,        // QR không hợp lệ
  offline,          // Đã lưu offline
  alreadyScanned,   // Đã điểm danh rồi
  error,            // Lỗi khác
}

/// Entity cho kết quả quét QR
class ScanResultEntity extends Equatable {
  final ScanStatus status;
  final String message;
  final DateTime? attendanceTime;
  final double? distance;        // Khoảng cách với trường (meters)
  final String? attendanceId;

  const ScanResultEntity({
    required this.status,
    required this.message,
    this.attendanceTime,
    this.distance,
    this.attendanceId,
  });

  bool get isSuccess => status == ScanStatus.success || status == ScanStatus.offline;

  @override
  List<Object?> get props => [status, message, attendanceTime, distance, attendanceId];

  /// Get Vietnamese message for status
  static String getStatusMessage(ScanStatus status, {double? distance}) {
    switch (status) {
      case ScanStatus.success:
        return 'Điểm danh thành công!';
      case ScanStatus.expired:
        return 'Mã QR đã hết hạn. Vui lòng yêu cầu giáo viên tạo mã mới.';
      case ScanStatus.outOfRange:
        if (distance != null) {
          return 'Bạn đang ở xa lớp học ${distance.toStringAsFixed(0)}m. Vui lòng di chuyển gần hơn.';
        }
        return 'Vị trí của bạn không hợp lệ. Vui lòng di chuyển gần lớp học hơn.';
      case ScanStatus.invalidQR:
        return 'Mã QR không hợp lệ hoặc không thuộc hệ thống.';
      case ScanStatus.offline:
        return 'Đã lưu điểm danh offline. Sẽ tự động đồng bộ khi có mạng.';
      case ScanStatus.alreadyScanned:
        return 'Bạn đã điểm danh cho buổi học này rồi.';
      case ScanStatus.error:
        return 'Có lỗi xảy ra. Vui lòng thử lại.';
    }
  }
}

