import 'package:flutter_ios_android_platforms/data/datasources/remote/dashboard/dashboard_datasource.dart';
import 'package:flutter_ios_android_platforms/domain/entities/dashboard/dashboard_data_base_entity.dart';
import 'package:flutter_ios_android_platforms/domain/repositories/dashboard/dashboard_repository.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDataSource remote;

  DashboardRepositoryImpl(this.remote);

  @override
  Future<DashboardDataBaseEntity> getDashboardData(String role) async {}
}
