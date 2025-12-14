import 'package:json_annotation/json_annotation.dart';
import '../../../domain/entities/qr_attendance/scan_result_entity.dart';

part 'scan_response_model.g.dart';

@JsonSerializable()
class ScanResponseModel {
  final String status;
  final String message;
  final String? attendanceTime;
  final double? distance;
  final String? attendanceId;

  const ScanResponseModel({
    required this.status,
    required this.message,
    this.attendanceTime,
    this.distance,
    this.attendanceId,
  });

  factory ScanResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ScanResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ScanResponseModelToJson(this);

  /// Convert to entity
  ScanResultEntity toEntity() {
    return ScanResultEntity(
      status: _parseStatus(status),
      message: message,
      attendanceTime: attendanceTime != null 
          ? DateTime.parse(attendanceTime!)
          : null,
      distance: distance,
      attendanceId: attendanceId,
    );
  }

  static ScanStatus _parseStatus(String status) {
    switch (status.toLowerCase()) {
      case 'success':
        return ScanStatus.success;
      case 'expired':
        return ScanStatus.expired;
      case 'out_of_range':
      case 'outofrange':
        return ScanStatus.outOfRange;
      case 'invalid':
      case 'invalid_qr':
        return ScanStatus.invalidQR;
      case 'already_scanned':
        return ScanStatus.alreadyScanned;
      default:
        return ScanStatus.error;
    }
  }
}

