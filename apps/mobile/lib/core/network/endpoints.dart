import 'package:flutter_dotenv/flutter_dotenv.dart';

class Endpoints {
  static final String baseUrl = "${dotenv.env['API_BASE_URL']}/api";

  // ================== AUTH ==================
  static const String login = "/v1/auth/login";
  static const String register = "/v1/auth/register";
  static const String logout = "/v1/auth/logout";
  static const String changePassword = "/v1/auth/change-password";
  static const String forgetPassword = "/v1/auth/forget-password";

  // ================== USERS ==================
  static const String users = "/v1/users";
  static const String userProfile = "/v1/users/profile";
  static String userById(String id) => "/v1/users/$id";

  // ================== CLASSES ==================
  static const String classes = "/v1/classes";
  static String classDetail(String id) => "/v1/classes/$id";

  // ================== SCHOOLS ==================
  static const String schools = "/v1/schools";
  static String schoolDetail(String id) => "/v1/schools/$id";

  // ================== ROLES ==================
  static const String roles = "/v1/roles";
}
