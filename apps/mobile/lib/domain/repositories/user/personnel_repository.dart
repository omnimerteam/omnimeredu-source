import 'package:flutter_ios_android_platforms/domain/entities/query/default_query_entity.dart';
import 'package:flutter_ios_android_platforms/domain/entities/user/base_user_entity.dart';

abstract class PersonnelRepository {
  Future<List<BaseUserEntity>> getAllPersonnel(DefaultQueryEntity query);
}
