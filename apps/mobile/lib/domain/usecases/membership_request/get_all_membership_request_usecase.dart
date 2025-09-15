import 'package:flutter_ios_android_platforms/domain/entities/membership_request/membership_request_entity.dart';
import 'package:flutter_ios_android_platforms/domain/repositories/school/membership_request_repository.dart';

class GetAllMembershipRequestsUseCase {
  final MembershipRequestRepository repository;

  GetAllMembershipRequestsUseCase(this.repository);

  Future<List<MembershipRequestEntity>> call({
    int page = 1,
    int limit = 20,
    Map<String, String>? sort,
    Map<String, dynamic>? filter,
  }) async {
    return await repository.getAllMembershipRequest(
      page: page,
      limit: limit,
      sort: sort,
      filter: filter,
    );
  }
}
