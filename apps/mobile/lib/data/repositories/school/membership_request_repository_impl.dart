import 'package:flutter_ios_android_platforms/data/datasources/remote/school/membership_request_data_source.dart';
import 'package:flutter_ios_android_platforms/data/models/membership_request/membership_request_model.dart';
import 'package:flutter_ios_android_platforms/domain/entities/membership_request/membership_request_entity.dart';
import 'package:flutter_ios_android_platforms/domain/repositories/school/membership_request_repository.dart';

class MembershipRequestRepositoryImpl implements MembershipRequestRepository {
  final MembershipRequestRemoteDataSource remote;

  MembershipRequestRepositoryImpl(this.remote);

  @override
  Future<List<MembershipRequestEntity>> getAllMembershipRequest({
    int page = 1,
    int limit = 20,
    Map<String, String>? sort,
    Map<String, dynamic>? filter,
  }) async {
    try {
      final models = await remote.getAllMembershipRequest(
        page: page,
        limit: limit,
        sort: sort,
        filter: filter,
      );
      return models.map((m) => m.toEntity()).toList();
    } catch (e, st) {
      print("❌ Lỗi khi lấy danh sách membership request: $e\n$st");
      throw Exception("Không thể lấy danh sách membership request");
    }
  }

  @override
  Future<MembershipRequestEntity> getMemberRequestById(String id) async {
    try {
      final model = await remote.getMemberRequestById(id);
      return model.toEntity();
    } catch (e) {
      throw Exception("Không thể lấy membership request: $e");
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
      throw Exception("Không thể tạo membership request: $e");
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
      throw Exception("Không thể cập nhật membership request: $e");
    }
  }

  @override
  Future<void> deleteMembershipRequest(String id) async {
    try {
      await remote.deleteMembershipRequest(id);
    } catch (e, st) {
      throw Exception("Xóa membership request thất bại: $e\n$st");
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
      throw Exception("Không thể cập nhật status membership request: $e");
    }
  }
}
