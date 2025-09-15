import { NextFunction, Request, Response } from "express";
import {
  sendCreated,
  sendSuccess,
  sendEmpty,
  sendUnauthorized,
  sendBadRequest,
  sendError,
} from "../../../common/utils/ResponseHelper";
import chalk from "chalk";
import { MembershipStatusEnum } from "../../../common/enum/membershipRequest.enum";
import { MembershipRequestService } from "../../services";
import { buildQueryOptions } from "../../../common/utils/buildQueryOptions";

class MembershipRequestController {
  private readonly membershipRequestService: MembershipRequestService;

  constructor(membershipRequestService: MembershipRequestService) {
    this.membershipRequestService = membershipRequestService;
  }

  async getAllMembershipRequest(
    req: Request,
    res: Response,
    next: NextFunction
  ): Promise<void> {
    const actorId = req.user?.id;
    const userRole = req.role;
    if (!userRole || !actorId) {
      sendUnauthorized(res);
      return;
    }

    const schoolId = req.user?.schoolId;
    const options = buildQueryOptions(req.query as any);

    try {
      const memberRequest =
        await this.membershipRequestService.getAllMembershipRequest(
          actorId,
          userRole,
          schoolId,
          options
        );
      if (!memberRequest || memberRequest.length === 0) {
        sendEmpty(res);
        return;
      }
      sendSuccess(res, memberRequest, "Lấy danh sách yêu cầu thành công");
    } catch (error) {
      console.log(
        chalk.red("[MEMBERSHIP] Error getting all memberRequest: ", error)
      );
      return next(error);
    }
  }

  async getMemberRequestById(req: Request, res: Response, next: NextFunction) {
    const actorId = req.user?.id;
    const userRole = req.role;
    const id = req.params.id;
    if (!userRole || !actorId) {
      sendUnauthorized(res);
      return;
    }
    if (!id) {
      sendBadRequest(res, "Thiếu ID yêu cầu");
      return;
    }

    try {
      const request = await this.membershipRequestService.getMemberRequestById(
        actorId,
        id
      );
      sendSuccess(res, request, "Lấy yêu cầu thành công");
    } catch (error) {
      console.log(
        chalk.red("[MEMBERSHIP] Error getMemberRequestById: ", error)
      );
      return next(error);
    }
  }

  async createMemberRequest(req: Request, res: Response, next: NextFunction) {
    const actorId = req.user?.id;
    const userRole = req.role;
    const data = req.body;
    if (!userRole || !actorId) {
      sendUnauthorized(res);
      return;
    }

    if (!data || !data.userId || !data.schoolId || !data.role || !data.action) {
      sendBadRequest(res, "Thiếu thông tin bắt buộc để tạo yêu cầu");
      return;
    }

    try {
      const created = await this.membershipRequestService.createMemberRequest(
        actorId,
        data
      );
      sendCreated(res, created, "Tạo yêu cầu thành công");
    } catch (error) {
      console.log(chalk.red("[MEMBERSHIP] Error createMemberRequest: ", error));
      return next(error);
    }
  }

  async updateMemberRequest(req: Request, res: Response, next: NextFunction) {
    const actorId = req.user?.id;
    const userRole = req.role;
    const id = req.params.id;
    const data = req.body;
    if (!userRole || !actorId) {
      sendUnauthorized(res);
      return;
    }
    if (!id) {
      sendBadRequest(res, "Thiếu ID yêu cầu");
      return;
    }

    try {
      const updated = await this.membershipRequestService.updateMemberRequest(
        actorId,
        id,
        data
      );
      sendSuccess(res, updated, "Cập nhật yêu cầu thành công");
    } catch (error) {
      console.log(chalk.red("[MEMBERSHIP] Error updateMemberRequest: ", error));
      return next(error);
    }
  }

  async deleteMemberRequest(req: Request, res: Response, next: NextFunction) {
    const actorId = req.user?.id;
    const userRole = req.role;
    const id = req.params.id;
    if (!userRole || !actorId) {
      sendUnauthorized(res);
      return;
    }
    if (!id) {
      sendBadRequest(res, "Thiếu ID yêu cầu");
      return;
    }

    try {
      await this.membershipRequestService.deleteMemberRequest(actorId, id);
      sendSuccess(res, null, "Xóa yêu cầu thành công");
    } catch (error) {
      console.log(chalk.red("[MEMBERSHIP] Error deleteMemberRequest: ", error));
      sendError(res, "Xóa yêu cầu thất bại", 500, error);
    }
  }

  async updateStatusMemberRequest(
    req: Request,
    res: Response,
    next: NextFunction
  ) {
    const actorId = req.user?.id;
    const userRole = req.role;
    const id = req.params.id;
    const status: MembershipStatusEnum = req.body.action;

    if (!userRole || !actorId) {
      sendUnauthorized(res);
      return;
    }
    if (!id || !status) {
      sendBadRequest(res, "Thiếu thông tin action hoặc ID");
      return;
    }

    try {
      const updated =
        await this.membershipRequestService.updateStatusMemberRequest(
          actorId,
          id,
          status
        );
      sendSuccess(res, updated, "Cập nhật action thành công");
    } catch (error) {
      console.log(
        chalk.red("[MEMBERSHIP] Error updateStatusMemberRequest: ", error)
      );
      return next(error);
    }
  }
}

export default MembershipRequestController;
