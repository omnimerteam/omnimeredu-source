import 'app_config.dart';

class Endpoints {
  static String get baseUrl => AppConfig.baseUrl;

  // ================== AUTH (Firebase) ==================
  static const String login = "/v1/auth/login";
  static const String register = "/v1/auth/register";
  static const String logout = "/v1/auth/logout";
  static const String changePassword = "/v1/auth/change-password";
  static const String forgetPassword = "/v1/auth/forget-password";

  // ================== AUTH JWT ==================
  static const String jwtLogin = "/v1/auth-jwt/login";
  static const String jwtRegister = "/v1/auth-jwt/register";
  static const String jwtRefreshToken = "/v1/auth-jwt/refresh-token";
  static const String jwtChangePassword = "/v1/auth-jwt/change-password";
  static const String jwtForgetPassword = "/v1/auth-jwt/forget-password";
  static const String jwtLogout = "/v1/auth-jwt/logout";
  static const String jwtMe = "/v1/auth-jwt/me";

  // ================== CLASSES ==================
  static const String classes = "/v1/classes";
  static String classId(String id) => "/v1/classes/$id";
  static const classDetailView = "/v1/classes/view-model/class-detail";
  static String classDetailViewId(String id) =>
      "/v1/classes/view-model/class-detail/$id";
  static const String searchClassesInSchool = "/v1/classes/schools/search";
  static String addStudentToClass(String id) => "/v1/classes/$id/students/add";
  static String removeStudentFromClass(String id) =>
      "/v1/classes/$id/students/remove";
  static String transferClass(String id) => "/v1/classes/$id/students/transfer";

  // ================== SCHOOLS ==================
  static const String schools = "/v1/schools";
  static String schoolId(String id) => "/v1/schools/$id";
  static const String getSchoolDetailForSchoolAdmin =
      "/v1/schools/school-admin";
  static const String searchSchoolByEducationLevel = "/v1/schools/search/query";

  // ================== ROLES ==================
  static const String roles = "/v1/roles";
  static const String rolesPersonnel = "/v1/roles/roles-personnel";

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
  static const String getStudentSelector = "/v1/students/student-selector";

  // ================== PERSONNEL ==================
  static const String personnel = "/v1/personnel";
  static String updateRoleIdForPersonnel(String id) =>
      "/v1/personnel/update-role/$id";
  static String updateVerified(String id) =>
      "/v1/personnel/update-verified/$id";
  static String dismissPersonnel(String id) => "/v1/personnel/dismiss/$id";
  static String personnelId(String id) => "/v1/personnel/$id";
  static const String updateAvatar = "/v1/personnel/update-avatar";

  // ================== TEACHER ==================
  static const String teachers = "/v1/teachers";
  static String teacherId(String id) => "/v1/teachers/$id";

  // ================== MEMBERSHIP REQUEST ==================
  static const String teachingAssignment = "/v1/teaching-assignment";
  static String teachingAssignmentId(String id) =>
      "/v1/teaching-assignment/$id";
  static String getTeachingAssignmentByTeacherClassAndSchool(
    String teacherId,
    String schoolId,
    String classId,
  ) =>
      "/v1/teaching-assignment/teacherId-schoolId-classId/$teacherId/$schoolId/$classId";
  static String getAllAssignmentForTeacherInSchool(
    String teacherId,
    String schoolId,
  ) => "/v1/teaching-assignment/teacherId-schoolId/$teacherId/$schoolId";
  static String getClassesTeacherAssignByTeacherId(String teacherId) =>
      "/v1/teaching-assignment/teacherId/$teacherId";

  // ================== SCHOOL ADMIN ==================
  static String updatePositionSchoolAdmin(String id) =>
      "/v1/school-admins/update-position/$id";
  static String schoolAdminId(String id) => "/v1/school-admin/$id";

  // ================== ATTENDANCE ==================
  static const String attendances = "/v1/attendances";
  static const String initializeClassAttendance =
      "/v1/attendances/initialize-class-attendance";
  static const String getClassAttendanceRecordView =
      "/v1/attendances/class-attendance-record/view";
  static String deleteAttendance(String id) => "/v1/attendances/$id";
  static String exportAttendanceExcel(String id) =>
      "/v1/attendances/$id/export";

  // ================== DETAIL RECORD ==================
  static String updateStatusDetailRecord(String id) =>
      "/v1/details-records/update-status/$id";
  static String getAttendanceRecordsById(String attendanceId) =>
      "/v1/details-records/attendance-records/$attendanceId";

  // ================== DETAIL RECORD ==================
  static String staffId(String id) => "/v1/details-records/update-status/$id";

  // ================== QR ATTENDANCE ==================
  static String generateQRCode(String attendanceId) =>
      "/v1/attendance/$attendanceId/qr";
  static const String submitAttendanceScan = "/v1/attendance/scan";

  // ================== UPLOAD ==================
  static const String uploadAvatar = "/v1/upload/avatar-temp";

  // ================== EXTRA_FEE ==================
  static const String extraFeeList = "/v1/extra-fees";
  static const String createExtraFee = "/v1/extra-fees";
  static String extraFeeById(String id) => "/v1/extra-fees/$id";
  static String updateExtraFee(String id) => "/v1/extra-fees/$id";
  static String deleteExtraFee(String id) => "/v1/extra-fees/$id";

  // ================== EXTRA_FEE ==================
  static const String discountPolicyList = "/v1/discount-policies";
  static const String createDiscountPolicy = "/v1/discount-policies";
  static String discountPolicyById(String id) => "/v1/discount-policies/$id";
  static String updateDiscountPolicy(String id) => "/v1/discount-policies/$id";
  static String deleteDiscountPolicy(String id) => "/v1/discount-policies/$id";
}
