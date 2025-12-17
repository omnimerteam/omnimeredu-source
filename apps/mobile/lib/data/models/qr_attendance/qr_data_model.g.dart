// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'qr_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QRDataModel _$QRDataModelFromJson(Map<String, dynamic> json) => QRDataModel(
      attendanceId: json['attendanceId'] as String,
      qrData: json['qrData'] as String,
      expiry: json['expiry'] as String,
      dynamicCode: json['dynamicCode'] as String?,
    );

Map<String, dynamic> _$QRDataModelToJson(QRDataModel instance) =>
    <String, dynamic>{
      'attendanceId': instance.attendanceId,
      'qrData': instance.qrData,
      'expiry': instance.expiry,
      'dynamicCode': instance.dynamicCode,
    };

