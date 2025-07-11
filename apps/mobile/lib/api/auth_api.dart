import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

/// [AuthApi] chịu trách nhiệm gọi các API liên quan đến xác thực và thông tin người dùng.
/// Các phương thức bên trong class này thực hiện các request HTTP RESTful
/// đến backend server đã cấu hình trong biến môi trường.
class AuthApi {
  /// Cơ sở URL của API, được cấu hình qua file `.env`.
  /// Ví dụ: API_BASE_URL=https://api.example.com/api
  final String baseUrl = dotenv.env['API_BASE_URL']!;

  /// Đăng ký người dùng mới vào hệ thống.
  ///
  /// Gửi thông tin người dùng bao gồm:
  /// [uid]: UID của người dùng trên Firebase.
  /// [email]: Địa chỉ email.
  /// [fullName]: Họ và tên đầy đủ.
  /// [gender]: Giới tính.
  /// [phone]: Số điện thoại.
  /// [role]: Vai trò (ví dụ: admin, student, teacher).
  ///
  /// Nếu backend trả về lỗi, phương thức này sẽ ném ra một [Exception].
  Future<void> registerUser({
    required String uid,
    required String email,
    required String fullName,
    required String gender,
    required String phone,
    required String role,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/user/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'uid': uid,
        'email': email,
        'fullName': fullName,
        'gender': gender,
        'phone': phone,
        'role': role,
        'password': password,
      }),
    );

    if (response.statusCode != 200) {
      // TODO: Xử lý chi tiết hơn (ví dụ: phân loại lỗi theo mã status)
      throw Exception('Backend failed: ${response.body}');
    }
  }

  /// Lấy vai trò của người dùng theo UID.
  ///
  /// [uid]: UID người dùng trên Firebase.
  ///
  /// Trả về [String] vai trò của người dùng (ví dụ: admin, student).
  /// Nếu không tìm thấy người dùng, sẽ ném ra một [Exception].
  Future<String> getUserRoleByUid(String uid, String? idToken) async {
    final response = await http.get(
      Uri.parse('$baseUrl/user/$uid'),
      headers: {
        'Authorization': 'Bearer $idToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['role'];
    } else {
      // TODO: Có thể bổ sung logging hoặc xử lý lỗi chi tiết hơn.
      throw Exception('User not found');
    }
  }
}
