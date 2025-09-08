import 'package:flutter_ios_android_platforms/domain/entities/dashboard/dashboard_data_base_entity.dart';

abstract class DashboardRepository {
  Future<DashboardDataBaseEntity> getDashboardData(String role);
}
