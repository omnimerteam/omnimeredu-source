import '../../../../core/constants/enum_constant.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/api/endpoints.dart';
import '../../../models/school/membership_request_model.dart';
import '../../../../domain/entities/query/default_query_entity.dart';

class MembershipRequestRemoteDataSource {
  final ApiClient client;
  MembershipRequestRemoteDataSource(this.client);

  /// 🔹 Lấy tất cả membership request
  Future<List<MembershipRequestModel>> getAllMembershipRequest(
    DefaultQueryEntity query,
  ) async {
    final queryParams = query.toQueryBuilder().build();

    final res = await client.get<List<MembershipRequestModel>>(
      Endpoints.user.membershipRequests,
      query: queryParams,
      parser: (data) {
        if (data is List) {
          return data.map((e) => MembershipRequestModel.fromJson(e)).toList();
        }
        return [];
      },
    );

    if (res.success) {
      return res.data ?? [];
    } else {
      throw Exception(
        res.message.isNotEmpty
            ? res.message
            : "Không thể lấy danh sách membership request",
      );
    }
  }

  /// 🔹 Lấy membership request theo ID
  Future<MembershipRequestModel> getMemberRequestById(String id) async {
    final res = await client.get<MembershipRequestModel>(
      Endpoints.user.membershipRequestId(id),
      parser: (data) {
        if (data is Map<String, dynamic>) {
          return MembershipRequestModel.fromJson(data);
        }
        throw Exception("API không trả về membership request hợp lệ");
      },
    );

    if (res.success && res.data != null) {
      return res.data!;
    } else {
      throw Exception(
        res.message.isNotEmpty
            ? res.message
            : "Không thể lấy membership request",
      );
    }
  }

  /// 🔹 Tạo membership request mới (không trả dữ liệu)
  Future<void> createMembershipRequest(
    MembershipRequestModel createData,
  ) async {
    final res = await client.post<void>(
      Endpoints.user.membershipRequests,
      data: createData.toJson(),
    );

    if (!res.success) {
      throw Exception(
        res.message.isNotEmpty
            ? res.message
            : "Không thể tạo membership request",
      );
    }
  }

  /// 🔹 Cập nhật membership request (không trả dữ liệu)
  Future<void> updateMembershipRequest(
    MembershipRequestModel updateData,
  ) async {
    final res = await client.put<void>(
      Endpoints.user.membershipRequestId(updateData.id!),
      data: updateData.toJson(),
    );

    if (!res.success) {
      throw Exception(
        res.message.isNotEmpty
            ? res.message
            : "Không thể cập nhật membership request",
      );
    }
  }

  /// 🔹 Xóa membership request theo ID (không trả dữ liệu)
  Future<void> deleteMembershipRequest(String id) async {
    final res = await client.delete<void>(
      Endpoints.user.membershipRequestId(id),
    );

    if (!res.success) {
      throw Exception(
        res.message.isNotEmpty
            ? res.message
            : "Không thể xóa membership request",
      );
    }
  }

  /// 🔹 Cập nhật status cho membership request
  /// -> Trả về status mới để UI hiển thị
  Future<MembershipStatusEnum> updateStatusMemberRequest(
    String id,
    MembershipStatusEnum status,
  ) async {
    final res = await client.patch<MembershipStatusEnum>(
      Endpoints.user.membershipRequestStatus(id),
      data: {"status": status.name},
      parser: (data) {
        if (data is Map<String, dynamic> && data["status"] != null) {
          return MembershipStatusEnum.values.firstWhere(
            (e) => e.name == data["status"],
            orElse: () => throw Exception("Status không hợp lệ"),
          );
        }
        // If generic success, return the status we sent assuming success
        return status;
      },
    );

    if (res.success && res.data != null) {
      return res.data!;
    } else {
      throw Exception(
        res.message.isNotEmpty ? res.message : "Không thể cập nhật status",
      );
    }
  }
}
