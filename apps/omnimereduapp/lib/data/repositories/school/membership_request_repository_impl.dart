import '../../../core/constants/enum_constant.dart';
import '../../../core/error/failures.dart';
import '../../datasources/remote/school/membership_request_data_source.dart';
import '../../models/membership_request/membership_request_model.dart';
import '../../../domain/entities/membership_request/membership_request_entity.dart';
import '../../../domain/entities/query/default_query_entity.dart';
import '../../../domain/repositories/school/membership_request_repository.dart';

class MembershipRequestRepositoryImpl implements MembershipRequestRepository {
  final MembershipRequestRemoteDataSource remote;

  MembershipRequestRepositoryImpl(this.remote);

  @override
  Future<List<MembershipRequestEntity>> getAllMembershipRequest(
    DefaultQueryEntity query,
  ) async {
    try {
      final models = await remote.getAllMembershipRequest(query);
      return models.map((m) => m.toEntity()).toList();
    } catch (e) {
      throw ServerFailure("Không thể lấy danh sách membership request");
    }
  }

  @override
  Future<MembershipRequestEntity> getMemberRequestById(String id) async {
    try {
      final model = await remote.getMemberRequestById(id);
      return model.toEntity();
    } catch (e) {
      throw ServerFailure("Không thể lấy membership request: $e");
    }
  }

  @override
  Future<void> createMembershipRequest(
    MembershipRequestEntity createData,
  ) async {
    try {
      final model = MembershipRequestModel.fromEntity(createData);
      await remote.createMembershipRequest(model);
    } catch (e) {
      throw ServerFailure("Không thể tạo membership request: $e");
    }
  }

  @override
  Future<void> updateMembershipRequest(
    MembershipRequestEntity updateData,
  ) async {
    try {
      final model = MembershipRequestModel.fromEntity(updateData);
      await remote.updateMembershipRequest(model);
    } catch (e) {
      throw ServerFailure("Không thể cập nhật membership request: $e");
    }
  }

  @override
  Future<void> deleteMembershipRequest(String id) async {
    try {
      await remote.deleteMembershipRequest(id);
    } catch (e, st) {
      throw ServerFailure("Xóa membership request thất bại: $e\n$st");
    }
  }

  @override
  Future<MembershipStatusEnum> updateStatusMemberRequest(
    String id,
    MembershipStatusEnum status,
  ) async {
    try {
      return await remote.updateStatusMemberRequest(id, status);
    } catch (e) {
      throw ServerFailure("Không thể cập nhật status membership request: $e");
    }
  }
}
