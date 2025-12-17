import 'package:equatable/equatable.dart';
import '../../../core/constants/enum_constant.dart';
import '../../../core/usecases/usecase.dart';
import '../../repositories/school/membership_request_repository.dart';

class UpdateStatusMembershipRequestUseCase
    extends UseCase<MembershipStatusEnum, UpdateStatusParams> {
  final MembershipRequestRepository repository;

  UpdateStatusMembershipRequestUseCase(this.repository);

  @override
  Future<MembershipStatusEnum> call(UpdateStatusParams params) async {
    return await repository.updateStatusMemberRequest(params.id, params.status);
  }
}

class UpdateStatusParams extends Equatable {
  final String id;
  final MembershipStatusEnum status;

  const UpdateStatusParams({required this.id, required this.status});

  @override
  List<Object> get props => [id, status];
}
