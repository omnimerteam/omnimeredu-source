import '../../../core/add_jwt.dart';
import '../../../core/network/api_client.dart';

/// Base class cho các remote data source
/// Sử dụng AppAuthProvider để lấy token thay vì hardcode Firebase
abstract class BaseRemoteDataSource {
  final ApiClient client;
  final AppAuthProvider authProvider;

  BaseRemoteDataSource(this.client, this.authProvider);

  /// Lấy headers với token
  Future<Map<String, String>> get authHeaders async {
    final token = await authProvider.getAuthToken();
    return token != null ? {'Authorization': 'Bearer $token'} : {};
  }

  /// Helper method để merge custom headers với auth headers
  Future<Map<String, String>> mergeHeaders([
    Map<String, dynamic>? customHeaders,
  ]) async {
    final auth = await authHeaders;
    if (customHeaders != null) {
      return {
        ...auth,
        ...customHeaders.map((k, v) => MapEntry(k, v.toString())),
      };
    }
    return auth;
  }
}
