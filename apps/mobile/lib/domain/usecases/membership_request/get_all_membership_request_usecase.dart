import 'package:flutter_ios_android_platforms/domain/entities/membership_request/membership_request_entity.dart';
import 'package:flutter_ios_android_platforms/domain/entities/query/default_query_entity.dart';
import 'package:flutter_ios_android_platforms/domain/repositories/school/membership_request_repository.dart';

class GetAllMembershipRequestsUseCase {
  final MembershipRequestRepository repository;

  GetAllMembershipRequestsUseCase(this.repository);

  Future<List<MembershipRequestEntity>> call(DefaultQueryEntity query) async {
    return await repository.getAllMembershipRequest(query);
  }
}
