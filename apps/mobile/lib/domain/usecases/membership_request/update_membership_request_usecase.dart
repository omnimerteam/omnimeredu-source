import '../../../core/usecases/usecase.dart';
import '../../entities/school/membership_request_entity.dart';
import '../../repositories/school/membership_request_repository.dart';

class UpdateMembershipRequestUseCase
    extends UseCase<void, MembershipRequestEntity> {
  final MembershipRequestRepository repository;

  UpdateMembershipRequestUseCase(this.repository);

  @override
  Future<void> call(MembershipRequestEntity params) async {
    return await repository.updateMembershipRequest(params);
  }
}
