// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scan_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScanRequestModel _$ScanRequestModelFromJson(Map<String, dynamic> json) =>
    ScanRequestModel(
      qrData: json['qrData'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      deviceId: json['deviceId'] as String,
      timestamp: json['timestamp'] as String,
    );

Map<String, dynamic> _$ScanRequestModelToJson(ScanRequestModel instance) =>
    <String, dynamic>{
      'qrData': instance.qrData,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'deviceId': instance.deviceId,
      'timestamp': instance.timestamp,
    };

