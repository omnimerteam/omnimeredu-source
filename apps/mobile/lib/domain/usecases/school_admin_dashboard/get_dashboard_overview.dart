import 'package:flutter_ios_android_platforms/domain/entities/dashboard/school_admin/dashboard_overview_entity.dart';
import 'package:flutter_ios_android_platforms/domain/repositories/dashboard/school_admin_dashboard_repository.dart';

class GetDashboardSummaryUseCase {
  final SchoolAdminDashboardRepository repository;

  GetDashboardSummaryUseCase(this.repository);

  Future<DashboardOverviewEntity> call() async {
    return await repository.getSummary();
  }
}
