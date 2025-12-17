import 'package:json_annotation/json_annotation.dart';

part 'scan_request_model.g.dart';

@JsonSerializable()
class ScanRequestModel {
  final String qrData;
  final double latitude;
  final double longitude;
  final String deviceId;
  final String timestamp;

  const ScanRequestModel({
    required this.qrData,
    required this.latitude,
    required this.longitude,
    required this.deviceId,
    required this.timestamp,
  });

  factory ScanRequestModel.fromJson(Map<String, dynamic> json) =>
      _$ScanRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$ScanRequestModelToJson(this);
}

