import 'package:json_annotation/json_annotation.dart';
import '../../../domain/entities/qr_attendance/qr_code_entity.dart';

part 'qr_data_model.g.dart';

@JsonSerializable()
class QRDataModel {
  final String attendanceId;
  final String qrData;
  final String expiry;
  final String? dynamicCode;

  const QRDataModel({
    required this.attendanceId,
    required this.qrData,
    required this.expiry,
    this.dynamicCode,
  });

  factory QRDataModel.fromJson(Map<String, dynamic> json) =>
      _$QRDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$QRDataModelToJson(this);

  /// Convert model to entity
  QRCodeEntity toEntity() {
    return QRCodeEntity(
      attendanceId: attendanceId,
      qrData: qrData,
      expiry: DateTime.parse(expiry),
      dynamicCode: dynamicCode,
    );
  }

  /// Convert entity to model
  factory QRDataModel.fromEntity(QRCodeEntity entity) {
    return QRDataModel(
      attendanceId: entity.attendanceId,
      qrData: entity.qrData,
      expiry: entity.expiry.toIso8601String(),
      dynamicCode: entity.dynamicCode,
    );
  }
}

