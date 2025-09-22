import 'package:flutter_ios_android_platforms/core/network/app_config.dart';

class Endpoints {
  static String get baseUrl => AppConfig.baseUrl;

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
  static String classId(String id) => "/v1/classes/$id";
  static const classDetailView = "/v1/classes/view-model/class-detail";
  static const String searchClassesInSchool = "/v1/classes/schools/search";

  // ================== SCHOOLS ==================
  static const String schools = "/v1/schools";
  static String schoolId(String id) => "/v1/schools/$id";
  static const String getSchoolDetailForSchoolAdmin =
      "/v1/schools/school-admin";
  static const String searchSchoolByEducationLevel = "/v1/schools/search/query";

  // ================== ROLES ==================
  static const String roles = "/v1/roles";

  // ================== SCHOOLADMIN DASHBOARD ==================
  static const String getSummary = "/v1/school-admin-dashboard/get-summary";
  static const String getSchoolAttendanceStats =
      "/v1/school-admin-dashboard/get-school-attendance-stats";

  // ================== MEMBERSHIP REQUEST ==================
  static const String membershipRequests = "/v1/membership-request";
  static String membershipRequestId(String id) => "/v1/membership-request/$id";
  static String membershipRequestStatus(String id) =>
      "/v1/membership-request/$id/status";

  // ================== SCHOOLS ==================
  static const String grades = "/v1/grades";
  static String gradeId(String id) => "/v1/grades/$id";
  static const String gradeSelect = "/v1/grades/select/box";

  // ================== STUDENTS ==================
  static const String students = "/v1/students";
  static String studentId(String id) => "/v1/students/$id";

  // ================== PERSONNEL ==================
  static const String personnel = "/v1/personnel";

  // ================== TEACHER ==================
  static const String teachers = "/v1/teachers";
  static String teacherId(String id) => "/v1/teachers/$id";
}
