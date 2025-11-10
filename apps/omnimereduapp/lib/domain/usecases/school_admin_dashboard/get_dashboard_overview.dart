import '../../entities/dashboard/school_admin/dashboard_overview_entity.dart';
import '../../repositories/dashboard/school_admin_dashboard_repository.dart';

class GetDashboardSummaryUseCase {
  final SchoolAdminDashboardRepository repository;

  GetDashboardSummaryUseCase(this.repository);

  Future<DashboardOverviewEntity> call() async {
    return await repository.getSummary();
  }
}
