// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offline_scan_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OfflineScanModel _$OfflineScanModelFromJson(Map<String, dynamic> json) =>
    OfflineScanModel(
      id: (json['id'] as num?)?.toInt(),
      qrData: json['qrData'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      deviceId: json['deviceId'] as String,
      scanTime: json['scanTime'] as String,
      isSynced: json['isSynced'] as bool? ?? false,
      errorMessage: json['errorMessage'] as String?,
    );

Map<String, dynamic> _$OfflineScanModelToJson(OfflineScanModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'qrData': instance.qrData,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'deviceId': instance.deviceId,
      'scanTime': instance.scanTime,
      'isSynced': instance.isSynced,
      'errorMessage': instance.errorMessage,
    };

