import '../../../core/usecases/usecase.dart';
import '../../entities/school/membership_request_entity.dart';
import '../../repositories/school/membership_request_repository.dart';

class CreateMembershipRequestUseCase
    extends UseCase<void, MembershipRequestEntity> {
  final MembershipRequestRepository repository;

  CreateMembershipRequestUseCase(this.repository);

  @override
  Future<void> call(MembershipRequestEntity params) async {
    return await repository.createMembershipRequest(params);
  }
}
