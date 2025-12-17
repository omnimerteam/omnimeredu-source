// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scan_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScanResponseModel _$ScanResponseModelFromJson(Map<String, dynamic> json) =>
    ScanResponseModel(
      status: json['status'] as String,
      message: json['message'] as String,
      attendanceTime: json['attendanceTime'] as String?,
      distance: (json['distance'] as num?)?.toDouble(),
      attendanceId: json['attendanceId'] as String?,
    );

Map<String, dynamic> _$ScanResponseModelToJson(ScanResponseModel instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'attendanceTime': instance.attendanceTime,
      'distance': instance.distance,
      'attendanceId': instance.attendanceId,
    };

