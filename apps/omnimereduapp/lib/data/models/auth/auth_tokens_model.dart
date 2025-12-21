import 'package:json_annotation/json_annotation.dart';
import 'auth_user_model.dart';

part 'auth_tokens_model.g.dart';

/// Model chứa JWT tokens và thông tin user sau khi login
@JsonSerializable()
class AuthTokensModel {
  final String accessToken;
  final String refreshToken;
  final AuthUserModel? user;

  const AuthTokensModel({
    required this.accessToken,
    required this.refreshToken,
    this.user,
  });

  factory AuthTokensModel.fromJson(Map<String, dynamic> json) =>
      _$AuthTokensModelFromJson(json);

  Map<String, dynamic> toJson() => _$AuthTokensModelToJson(this);

  /// Tạo instance từ response login/register của API
  factory AuthTokensModel.fromApiResponse(Map<String, dynamic> json) {
    return AuthTokensModel(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      user: json['user'] != null
          ? AuthUserModel.fromJson(json['user'] as Map<String, dynamic>)
          : null,
    );
  }

  AuthTokensModel copyWith({
    String? accessToken,
    String? refreshToken,
    AuthUserModel? user,
  }) {
    return AuthTokensModel(
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      user: user ?? this.user,
    );
  }
}
