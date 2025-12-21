import '../../../../core/add_jwt.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/endpoints.dart';
import '../../../models/schoolAdminDashboard/attendance_stats_model.dart';
import '../../../models/schoolAdminDashboard/dashboard_overview_model.dart';
import '../base_remote_data_source.dart';

class SchoolAdminDashboardRemoteDataSource extends BaseRemoteDataSource {
  SchoolAdminDashboardRemoteDataSource(
    ApiClient client,
    AppAuthProvider authProvider,
  ) : super(client, authProvider);

  Future<DashboardOverviewModel> getSummary() async {
    final headers = await authHeaders;

    final res = await client.get<DashboardOverviewModel>(
      Endpoints.getSummary,
      headers: headers,
      parser: (data) => DashboardOverviewModel.fromJson(data),
    );

    if (!res.success) {
      throw Exception(res.message ?? "Không lấy được dashboard summary");
    }

    return res.data!;
  }

  Future<AttendanceStatsModel> getSchoolAttendanceStats() async {
    final headers = await authHeaders;

    final res = await client.get<AttendanceStatsModel>(
      Endpoints.getSchoolAttendanceStats,
      headers: headers,
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
