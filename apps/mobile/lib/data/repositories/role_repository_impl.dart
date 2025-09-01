import 'package:flutter_ios_android_platforms/core/utils/logger.dart';
import '../../domain/entities/role.dart';
import '../../domain/repositories/role_repository.dart';
import '../datasources/remote/role_remote_datasource.dart';

class RoleRepositoryImpl implements RoleRepository {
  final RoleRemoteDataSource remoteDataSource;

  RoleRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<RoleEntity>> getAllRoles() async {
    final models = await remoteDataSource.fetchRoles();
    logger.i("👉 Models nhận từ remote: $models");

    final entities = models.map((m) => m.toEntity()).toList();
    logger.i("👉 Entities mapped: $entities");

    return entities;
  }
}
