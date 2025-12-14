import 'package:json_annotation/json_annotation.dart';

part 'offline_scan_model.g.dart';

/// Model để lưu dữ liệu quét offline vào local database
@JsonSerializable()
class OfflineScanModel {
  final int? id;              // Local database ID
  final String qrData;
  final double latitude;
  final double longitude;
  final String deviceId;
  final String scanTime;
  final bool isSynced;
  final String? errorMessage;

  const OfflineScanModel({
    this.id,
    required this.qrData,
    required this.latitude,
    required this.longitude,
    required this.deviceId,
    required this.scanTime,
    this.isSynced = false,
    this.errorMessage,
  });

  factory OfflineScanModel.fromJson(Map<String, dynamic> json) =>
      _$OfflineScanModelFromJson(json);

  Map<String, dynamic> toJson() => _$OfflineScanModelToJson(this);

  /// Convert to database map
  Map<String, dynamic> toDatabase() {
    return {
      if (id != null) 'id': id,
      'qrData': qrData,
      'latitude': latitude,
      'longitude': longitude,
      'deviceId': deviceId,
      'scanTime': scanTime,
      'isSynced': isSynced ? 1 : 0,
      'errorMessage': errorMessage,
    };
  }

  /// Create from database map
  factory OfflineScanModel.fromDatabase(Map<String, dynamic> map) {
    return OfflineScanModel(
      id: map['id'] as int?,
      qrData: map['qrData'] as String,
      latitude: map['latitude'] as double,
      longitude: map['longitude'] as double,
      deviceId: map['deviceId'] as String,
      scanTime: map['scanTime'] as String,
      isSynced: map['isSynced'] == 1,
      errorMessage: map['errorMessage'] as String?,
    );
  }

  /// Create a copy with updated fields
  OfflineScanModel copyWith({
    int? id,
    String? qrData,
    double? latitude,
    double? longitude,
    String? deviceId,
    String? scanTime,
    bool? isSynced,
    String? errorMessage,
  }) {
    return OfflineScanModel(
      id: id ?? this.id,
      qrData: qrData ?? this.qrData,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      deviceId: deviceId ?? this.deviceId,
      scanTime: scanTime ?? this.scanTime,
      isSynced: isSynced ?? this.isSynced,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

