import '../../../core/usecases/usecase.dart';
import '../../repositories/school/membership_request_repository.dart';

class DeleteMembershipRequestUseCase extends UseCase<void, String> {
  final MembershipRequestRepository repository;

  DeleteMembershipRequestUseCase(this.repository);

  @override
  Future<void> call(String params) async {
    return await repository.deleteMembershipRequest(params);
  }
}
