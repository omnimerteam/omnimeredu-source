import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/auth/auth_tokens_model.dart';
import '../../models/auth/auth_user_model.dart';
import '../../../services/token_storage_service.dart';

abstract class AuthLocalDataSource {
  Future<void> saveTokens(AuthTokensModel tokens);
  Future<AuthTokensModel?> getTokens();
  Future<void> clearTokens();
  Future<void> saveUser(AuthUserModel user);
  Future<AuthUserModel?> getUser();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final TokenStorageService tokenService;
  final SharedPreferences sharedPreferences;

  static const _userKey = 'AUTH_USER_DATA';

  AuthLocalDataSourceImpl({
    required this.tokenService,
    required this.sharedPreferences,
  });

  @override
  Future<void> saveTokens(AuthTokensModel tokens) async {
    await tokenService.saveTokens(
      accessToken: tokens.accessToken,
      refreshToken: tokens.refreshToken,
    );
    if (tokens.user != null) {
      await saveUser(tokens.user!);
    }
  }

  @override
  Future<AuthTokensModel?> getTokens() async {
    final accessToken = await tokenService.getAccessToken();
    final refreshToken = await tokenService.getRefreshToken();

    if (accessToken == null || refreshToken == null) {
      return null;
    }

    final user = await getUser();

    return AuthTokensModel(
      accessToken: accessToken,
      refreshToken: refreshToken,
      user: user,
    );
  }

  @override
  Future<void> clearTokens() async {
    await tokenService.clearTokens();
    await sharedPreferences.remove(_userKey);
  }

  @override
  Future<void> saveUser(AuthUserModel user) async {
    final userJson = jsonEncode(user.toJson());
    await sharedPreferences.setString(_userKey, userJson);
  }

  @override
  Future<AuthUserModel?> getUser() async {
    final userJson = sharedPreferences.getString(_userKey);
    if (userJson == null) return null;
    try {
      return AuthUserModel.fromJson(jsonDecode(userJson));
    } catch (e) {
      return null;
    }
  }
}
