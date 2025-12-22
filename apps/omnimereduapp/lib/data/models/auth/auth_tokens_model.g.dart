// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_tokens_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthTokensModel _$AuthTokensModelFromJson(Map<String, dynamic> json) =>
    AuthTokensModel(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      user: json['user'] == null
          ? null
          : AuthUserModel.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AuthTokensModelToJson(AuthTokensModel instance) =>
    <String, dynamic>{
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
      'user': instance.user,
    };
