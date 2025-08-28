import 'package:flutter_dotenv/flutter_dotenv.dart';

class Endpoints {
  static final String baseUrl = "${dotenv.env['API_BASE_URL']}/api";

  // ================== AUTH ==================
  static const String login = "/auth/login";
  static const String register = "/auth/register";
  static const String logout = "/auth/logout";
  static const String changePassword = "/auth/change-password";
  static const String forgetPassword = "/auth/forget-password";

  // ================== USERS ==================
  static const String users = "/users";
  static const String userProfile = "/users/profile";
  static String userById(String id) => "/users/$id";

  // ================== CLASSES ==================
  static const String classes = "/classes";
  static String classDetail(String id) => "/classes/$id";

  // ================== SCHOOLS ==================
  static const String schools = "/schools";
  static String schoolDetail(String id) => "/schools/$id";
}
