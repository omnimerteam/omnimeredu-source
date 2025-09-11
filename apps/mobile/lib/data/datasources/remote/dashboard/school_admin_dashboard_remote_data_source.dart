import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_ios_android_platforms/core/network/api_client.dart';
import 'package:flutter_ios_android_platforms/core/network/endpoints.dart';
import 'package:flutter_ios_android_platforms/core/utils/logger.dart';
import 'package:flutter_ios_android_platforms/data/models/schoolAdminDashboard/attendance_stats_model.dart';
import 'package:flutter_ios_android_platforms/data/models/schoolAdminDashboard/dashboard_overview_model.dart';

class SchoolAdminDashboardRemoteDataSource {
  final ApiClient client;

  SchoolAdminDashboardRemoteDataSource(this.client);

  Future<String?> _getIdToken() async {
    final user = FirebaseAuth.instance.currentUser;
    return await user?.getIdToken();
  }

  @override
  Future<DashboardOverviewModel> getSummary() async {
    final idToken = await _getIdToken();

    final res = await client.get<DashboardOverviewModel>(
      Endpoints.getSummary,
      headers: {"Authorization": "Bearer $idToken"},
      parser: (data) => DashboardOverviewModel.fromJson(data),
    );

    if (!res.success) {
      logger.e("getSummary failed: ${res.message}");
      throw Exception(res.message ?? "Không lấy được dashboard summary");
    }

    return res.data!;
  }

  @override
  Future<AttendanceStatsModel> getSchoolAttendanceStats() async {
    final idToken = await _getIdToken();

    final res = await client.get<AttendanceStatsModel>(
      Endpoints.getSchoolAttendanceStats,
      headers: {"Authorization": "Bearer $idToken"},
      parser: (data) => AttendanceStatsModel.fromJson(data),
    );

    if (!res.success) {
      logger.e("getSchoolAttendanceStats failed: ${res.message}");
      throw Exception(res.message ?? "Không lấy được thống kê điểm danh");
    }

    return res.data!;
  }
}
