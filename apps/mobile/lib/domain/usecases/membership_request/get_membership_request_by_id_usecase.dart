import '../../../core/usecases/usecase.dart';
import '../../entities/school/membership_request_entity.dart';
import '../../repositories/school/membership_request_repository.dart';

class GetMembershipRequestByIdUseCase
    extends UseCase<MembershipRequestEntity, String> {
  final MembershipRequestRepository repository;

  GetMembershipRequestByIdUseCase(this.repository);

  @override
  Future<MembershipRequestEntity> call(String params) async {
    return await repository.getMemberRequestById(params);
  }
}
