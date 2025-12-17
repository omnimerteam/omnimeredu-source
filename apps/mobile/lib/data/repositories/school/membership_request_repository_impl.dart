import '../../../domain/entities/query/default_query_entity.dart';
import '../../../domain/entities/school/membership_request_entity.dart';
import '../../../domain/repositories/school/membership_request_repository.dart';
import '../../datasources/remote/school/membership_request_remote_datasource.dart';
import '../../models/school/membership_request_model.dart';
import '../../../core/constants/enum_constant.dart';

class MembershipRequestRepositoryImpl implements MembershipRequestRepository {
  final MembershipRequestRemoteDataSource remoteDataSource;

  MembershipRequestRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> createMembershipRequest(
    MembershipRequestEntity createMembershipRequestData,
  ) async {
    final model = MembershipRequestModel.fromEntity(
      createMembershipRequestData,
    );
    await remoteDataSource.createMembershipRequest(model);
  }

  @override
  Future<void> deleteMembershipRequest(String id) async {
    await remoteDataSource.deleteMembershipRequest(id);
  }

  @override
  Future<List<MembershipRequestEntity>> getAllMembershipRequest(
    DefaultQueryEntity query,
  ) async {
    final models = await remoteDataSource.getAllMembershipRequest(query);
    return models; // Model extends Entity, so this is valid. Or .map for purity.
  }

  @override
  Future<MembershipRequestEntity> getMemberRequestById(String id) async {
    return await remoteDataSource.getMemberRequestById(id);
  }

  @override
  Future<void> updateMembershipRequest(
    MembershipRequestEntity updateMembershipRequestData,
  ) async {
    final model = MembershipRequestModel.fromEntity(
      updateMembershipRequestData,
    );
    await remoteDataSource.updateMembershipRequest(model);
  }

  @override
  Future<MembershipStatusEnum> updateStatusMemberRequest(
    String id,
    MembershipStatusEnum status,
  ) async {
    return await remoteDataSource.updateStatusMemberRequest(id, status);
  }
}
