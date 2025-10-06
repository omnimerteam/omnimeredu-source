import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_ios_android_platforms/core/network/api_client.dart';
import 'package:flutter_ios_android_platforms/core/network/endpoints.dart';
import 'package:flutter_ios_android_platforms/data/models/schoolAdminDashboard/attendance_stats_model.dart';
import 'package:flutter_ios_android_platforms/data/models/schoolAdminDashboard/dashboard_overview_model.dart';

class SchoolAdminDashboardRemoteDataSource {
  final ApiClient client;

  SchoolAdminDashboardRemoteDataSource(this.client);

  Future<String?> _getIdToken() async {
    final user = FirebaseAuth.instance.currentUser;
    return await user?.getIdToken();
  }

  Future<DashboardOverviewModel> getSummary() async {
    final idToken = await _getIdToken();

    final res = await client.get<DashboardOverviewModel>(
      Endpoints.getSummary,
      headers: {"Authorization": "Bearer $idToken"},
      parser: (data) => DashboardOverviewModel.fromJson(data),
    );

    if (!res.success) {
      throw Exception(res.message ?? "Không lấy được dashboard summary");
    }

    return res.data!;
  }

  Future<AttendanceStatsModel> getSchoolAttendanceStats() async {
    final idToken = await _getIdToken();

    final res = await client.get<AttendanceStatsModel>(
      Endpoints.getSchoolAttendanceStats,
      headers: {"Authorization": "Bearer $idToken"},
      parser: (data) {
        // Nếu backend trả về [] (list) => gói lại thành object cho model
        final list = (data as List<dynamic>? ?? [])
            .map((e) => ClassStatsModel.fromJson(e as Map<String, dynamic>))
            .toList();

        return AttendanceStatsModel(classAttendanceRates: list);
      },
    );

    if (!res.success) {
      throw Exception(res.message ?? "Không lấy được thống kê điểm danh");
    }

    return res.data!;
  }
}
