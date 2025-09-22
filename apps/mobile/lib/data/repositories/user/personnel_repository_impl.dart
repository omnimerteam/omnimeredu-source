import 'package:flutter_ios_android_platforms/data/datasources/remote/user/personnel_remote_data_source.dart';
import 'package:flutter_ios_android_platforms/domain/entities/query/default_query_entity.dart';
import 'package:flutter_ios_android_platforms/domain/entities/user/base_user_entity.dart';
import 'package:flutter_ios_android_platforms/domain/repositories/user/personnel_repository.dart';

class PersonnelRepositoryImpl implements PersonnelRepository {
  final PersonnelRemoteDataSource remote;

  PersonnelRepositoryImpl(this.remote);

  @override
  Future<List<BaseUserEntity>> getAllPersonnel(DefaultQueryEntity query) async {
    try {
      final models = await remote.getAllPersonnel(query);
      // Chuyển từng PersonnelModel -> BaseUserEntity
      return models.map((m) => m.toEntity()).toList();
    } catch (e) {
      throw Exception("Không thể lấy danh sách nhân sự: $e");
    }
  }
}
