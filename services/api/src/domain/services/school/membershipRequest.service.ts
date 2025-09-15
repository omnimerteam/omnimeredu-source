import { MembershipStatusEnum } from "../../../common/enum/membershipRequest.enum";
import { PaginationQueryOptions } from "../../../common/utils/buildQueryOptions";
import { DefaultLogger } from "../../../common/utils/DefaultLogger";
import { HttpError } from "../../../common/utils/HttpError";
import { buildPermissionFilterForMemberShipRequest } from "../../../common/utils/permissionFilter";
import { MembershipRequestRepository } from "../../repositories";

class MembershipRequestService {
  private readonly membershipRequestRepo: MembershipRequestRepository;
  private readonly logger: DefaultLogger;

  constructor(
    membershipRequestRepo: MembershipRequestRepository,
    logger: DefaultLogger
  ) {
    this.membershipRequestRepo = membershipRequestRepo;
    this.logger = logger;
  }

  /**
   * Lấy danh sách Membership Request
   * Super Admin là toàn bộ
   * School Admin chỉ trong trường */
  async getAllMembershipRequest(
    actorId: string,
    userRole: string,
    schoolId?: string,
    options?: PaginationQueryOptions
  ) {
    try {
      const filter = buildPermissionFilterForMemberShipRequest(
        userRole,
        schoolId,
        actorId
      );

      const membershipRequest = await this.membershipRequestRepo.findAll(
        filter,
        options
      );

      await this.logger.log({
        userId: actorId,
        action: "GET_ALL_MEMBERSHIP_REQUEST",
        roleSnapshot: userRole,
        metadata: {
          filter,
          options,
          count: membershipRequest.length,
        },
      });

      return membershipRequest;
    } catch (error) {
      await this.logger.log({
        userId: actorId,
        action: "GET_ALL_MEMBERSHIP_REQUEST_FAILED",
        roleSnapshot: userRole,
        metadata: { error: (error as Error).message },
      });

      throw error;
    }
  }

  // Tạo Membership Request mới
  async createMemberRequest(actorId: string, data: any) {
    try {
      const created = await this.membershipRequestRepo.create(data);

      await this.logger.log({
        userId: actorId,
        action: "CREATE_MEMBERSHIP_REQUEST",
        roleSnapshot: data.role,
        metadata: { membershipRequestId: created._id },
      });

      return created;
    } catch (error) {
      await this.logger.log({
        userId: actorId,
        action: "CREATE_MEMBERSHIP_REQUEST_FAILED",
        roleSnapshot: data.role,
        metadata: { error: (error as Error).message },
      });
      throw error;
    }
  }

  // 🔹 Lấy Membership Request theo ID
  async getMemberRequestById(actorId: string, id: string) {
    try {
      const request = await this.membershipRequestRepo.findById(id);
      if (!request)
        throw new HttpError(
          404,
          "Không tìm thấy yêu cầu",
          "MEMBERSHIP_NOT_FOUND"
        );

      await this.logger.log({
        userId: actorId,
        action: "GET_MEMBERSHIP_REQUEST_BY_ID",
        roleSnapshot: request.role,
        metadata: { membershipRequestId: id },
      });

      return request;
    } catch (error) {
      await this.logger.log({
        userId: actorId,
        action: "GET_MEMBERSHIP_REQUEST_BY_ID_FAILED",
        metadata: { error: (error as Error).message },
      });
      throw error;
    }
  }

  // 🔹 Update toàn bộ thông tin trừ status
  async updateMemberRequest(actorId: string, id: string, data: any) {
    try {
      const existing = await this.membershipRequestRepo.findById(id);

      if (!existing)
        throw new HttpError(
          404,
          "Không tìm thấy yêu cầu",
          "MEMBERSHIP_NOT_FOUND"
        );

      // Chỉ update fields ngoại trừ status
      const { status, ...updatableData } = data;
      const updated = await this.membershipRequestRepo.update(
        id,
        updatableData
      );

      await this.logger.log({
        userId: actorId,
        action: "UPDATE_MEMBERSHIP_REQUEST",
        roleSnapshot: existing.role,
        metadata: { membershipRequestId: id },
      });

      return updated;
    } catch (error) {
      await this.logger.log({
        userId: actorId,
        action: "UPDATE_MEMBERSHIP_REQUEST_FAILED",
        metadata: { error: (error as Error).message },
      });
      throw error;
    }
  }

  // 🔹 Delete Membership Request
  async deleteMemberRequest(actorId: string, id: string) {
    try {
      const success = await this.membershipRequestRepo.delete(id);
      if (!success)
        throw new HttpError(
          404,
          "Không tìm thấy yêu cầu",
          "MEMBERSHIP_NOT_FOUND"
        );

      await this.logger.log({
        userId: actorId,
        action: "DELETE_MEMBERSHIP_REQUEST",
        metadata: { membershipRequestId: id },
      });

      return success;
    } catch (error) {
      await this.logger.log({
        userId: actorId,
        action: "DELETE_MEMBERSHIP_REQUEST_FAILED",
        metadata: { error: (error as Error).message },
      });
      throw error;
    }
  }

  // 🔹 Update status (dành cho SchoolAdmin phê duyệt)
  async updateStatusMemberRequest(
    actorId: string,
    id: string,
    status: MembershipStatusEnum
  ) {
    try {
      const existing = await this.membershipRequestRepo.findById(id);
      if (!existing)
        throw new HttpError(
          404,
          "Không tìm thấy yêu cầu",
          "MEMBERSHIP_NOT_FOUND"
        );

      const updated = await this.membershipRequestRepo.update(id, { status });

      await this.logger.log({
        userId: actorId,
        action: "UPDATE_ACTION_MEMBERSHIP_REQUEST",
        roleSnapshot: existing.role,
        metadata: { membershipRequestId: id, status },
      });

      return updated;
    } catch (error) {
      await this.logger.log({
        userId: actorId,
        action: "UPDATE_ACTION_MEMBERSHIP_REQUEST_FAILED",
        metadata: { error: (error as Error).message },
      });
      throw error;
    }
  }
}

export default MembershipRequestService;
