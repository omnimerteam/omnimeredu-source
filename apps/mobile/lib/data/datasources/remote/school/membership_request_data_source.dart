import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_ios_android_platforms/core/constants/app_constant.dart';
import 'package:flutter_ios_android_platforms/core/network/api_client.dart';
import 'package:flutter_ios_android_platforms/core/network/endpoints.dart';
import 'package:flutter_ios_android_platforms/data/models/membership_request/membership_request_model.dart';
import 'package:flutter_ios_android_platforms/domain/entities/membership_request/membership_request_entity.dart';

class MembershipRequestRemoteDataSource {
  final ApiClient client;
  MembershipRequestRemoteDataSource(this.client);

  Future<String?> _getIdToken() async {
    final user = FirebaseAuth.instance.currentUser;
    return await user?.getIdToken();
  }

  /// 🔹 Lấy tất cả membership request
  Future<List<MembershipRequestModel>> getAllMembershipRequest({
    int page = AppConstants.defaultPage,
    int limit = AppConstants.defaultLimit,
    Map<String, String>? sort,
    Map<String, dynamic>? filter,
  }) async {
    final token = await _getIdToken();

    final queryParams = AppConstants.buildQueryParams(
      module: "membership",
      page: page,
      limit: limit,
      sort: sort,
      filter: filter,
    );

    final res = await client.get<List<MembershipRequestModel>>(
      Endpoints.membershipRequests,
      headers: {if (token != null) "Authorization": "Bearer $token"},
      query: queryParams,
      parser: (data) {
        if (data is List) {
          return data.map((e) => MembershipRequestModel.fromJson(e)).toList();
        }
        throw Exception("API không trả về danh sách membership request hợp lệ");
      },
    );

    if (res.success) {
      return res.data ?? [];
    } else {
      throw Exception(
        res.message ?? "Không thể lấy danh sách membership request",
      );
    }
  }

  /// 🔹 Lấy membership request theo ID
  Future<MembershipRequestModel> getMemberRequestById(String id) async {
    final token = await _getIdToken();

    final res = await client.get<MembershipRequestModel>(
      Endpoints.membershipRequestId(id),
      headers: {if (token != null) "Authorization": "Bearer $token"},
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
      throw Exception(res.message ?? "Không thể lấy membership request");
    }
  }

  /// 🔹 Tạo membership request mới (không trả dữ liệu)
  Future<void> createMembershipRequest(
    MembershipRequestModel createData,
  ) async {
    final token = await _getIdToken();

    final res = await client.post<void>(
      Endpoints.membershipRequests,
      headers: {if (token != null) "Authorization": "Bearer $token"},
      data: createData.toJson(),
    );

    if (!res.success) {
      throw Exception(res.message ?? "Không thể tạo membership request");
    }
  }

  /// 🔹 Cập nhật membership request (không trả dữ liệu)
  Future<void> updateMembershipRequest(
    MembershipRequestModel updateData,
  ) async {
    final token = await _getIdToken();

    final res = await client.put<void>(
      Endpoints.membershipRequestId(updateData.id),
      headers: {if (token != null) "Authorization": "Bearer $token"},
      data: updateData.toJson(),
    );

    if (!res.success) {
      throw Exception(res.message ?? "Không thể cập nhật membership request");
    }
  }

  /// 🔹 Xóa membership request theo ID (không trả dữ liệu)
  Future<void> deleteMembershipRequest(String id) async {
    final token = await _getIdToken();

    final res = await client.delete<void>(
      Endpoints.membershipRequestId(id),
      headers: {if (token != null) "Authorization": "Bearer $token"},
    );

    if (!res.success) {
      throw Exception(res.message ?? "Không thể xóa membership request");
    }
  }

  /// 🔹 Cập nhật status cho membership request
  /// -> Trả về status mới để UI hiển thị
  Future<MembershipStatusEnum> updateStatusMemberRequest(
    String id,
    MembershipStatusEnum status,
  ) async {
    final token = await _getIdToken();

    final res = await client.patch<MembershipStatusEnum>(
      Endpoints.membershipRequestStatus(id),
      headers: {if (token != null) "Authorization": "Bearer $token"},
      data: {"status": status.name},
      parser: (data) {
        if (data is Map<String, dynamic> && data["status"] != null) {
          return MembershipStatusEnum.values.firstWhere(
            (e) => e.name == data["status"],
            orElse: () => throw Exception("Status không hợp lệ"),
          );
        }
        throw Exception("API không trả về status hợp lệ");
      },
    );

    if (res.success && res.data != null) {
      return res.data!;
    } else {
      throw Exception(res.message ?? "Không thể cập nhật status");
    }
  }
}
