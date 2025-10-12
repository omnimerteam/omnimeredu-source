import { Request, Response, NextFunction } from "express";
import chalk from "chalk";
import {
  sendSuccess,
  sendCreated,
  sendNotFound,
  sendEmpty,
  sendUnauthorized,
} from "../../../../common/utils/ResponseHelper";
import { IDiscountPolicy } from "../../../models";
import DiscountPolicyService from "../../../services/school/tuition/dicountPolicy.service";
import { buildQueryOptions } from "../../../../common/utils/buildQueryOptions";

class DiscountPolicyController {
  private readonly discountPolicyService: DiscountPolicyService;
  constructor(discountPolicyService: DiscountPolicyService) {
    this.discountPolicyService = discountPolicyService;
  }

  async getAllDiscountPolicy(
    req: Request,
    res: Response,
    next: NextFunction
  ): Promise<void> {
    const actorId = req.user?.id;
    const userRole = req.role;
    const schoolId = req.user?.schoolId;
    if (!actorId || !userRole) {
      sendUnauthorized(res);
      return;
    }
    const options = buildQueryOptions(req.query as any);
    try {
      const discountPolicies =
        await this.discountPolicyService.getAllDisCountPolicy(
          actorId,
          schoolId,
          userRole,
          options
        );
      if (!discountPolicies || discountPolicies.length === 0) {
        sendEmpty(res);
        return;
      }

      sendSuccess(
        res,
        discountPolicies,
        "Lấy tất cả chính sách giảm giá thành công "
      );
    } catch (error) {
      console.log(
        chalk.red(
          "[Discount Policy] Error getting all discount policies: ",
          error
        )
      );
      return next(error);
    }
  }

  async getDiscountPolicyById(
    req: Request,
    res: Response,
    next: NextFunction
  ): Promise<void> {
    const actorId = req.user?.id;
    const userRole = req.role;
    if (!actorId || !userRole) {
      sendUnauthorized(res);
      return;
    }
    const discountPolicyId = req.params.id;

    try {
      const discountPolicy =
        await this.discountPolicyService.getDisCountPolicyById(
          discountPolicyId,
          actorId,
          userRole
        );
      if (!discountPolicy) {
        sendNotFound(res);
        return;
      }
      sendSuccess(
        res,
        discountPolicy,
        "Lấy chi tiết chính sách giảm giá thành công "
      );
    } catch (error) {
      console.log(
        chalk.red(
          "[Discount Policy] Error getting discount policy by ID: ",
          error
        )
      );
      return next(error);
    }
  }

  async createDiscountPolicy(
    req: Request,
    res: Response,
    next: NextFunction
  ): Promise<void> {
    const actorId = req.user?.id;
    const userRole = req.role;
    if (!actorId || !userRole) {
      sendUnauthorized(res);
      return;
    }
    const discountPolicyData: Partial<IDiscountPolicy> = req.body;

    try {
      const discountPolicy =
        await this.discountPolicyService.createDisCountPolicy(
          discountPolicyData,
          actorId,
          userRole
        );

      sendCreated(res, discountPolicy, "Thêm mới discount policy thành công ");
    } catch (error) {
      console.log(
        chalk.red("[Discount Policy] Error creatting discount policy: ", error)
      );
      return next(error);
    }
  }

  async updateDiscountPolicy(
    req: Request,
    res: Response,
    next: NextFunction
  ): Promise<void> {
    const actorId = req.user?.id;
    const userRole = req.role;
    if (!actorId || !userRole) {
      sendUnauthorized(res);
      return;
    }
    const discountPolicyData: Partial<IDiscountPolicy> = req.body;
    const discountPolicyId = req.params.id;

    try {
      const discountPolicy =
        await this.discountPolicyService.updateDisCountPolicy(
          discountPolicyData,
          discountPolicyId,
          actorId,
          userRole
        );

      sendSuccess(res, discountPolicy, "Cập nhật discount policy thành công ");
    } catch (error) {
      console.log(
        chalk.red("[Discount Policy] Error updatting discount policy: ", error)
      );
      return next(error);
    }
  }

  async deleteDiscountPolicy(
    req: Request,
    res: Response,
    next: NextFunction
  ): Promise<void> {
    const actorId = req.user?.id;
    const userRole = req.role;
    if (!actorId || !userRole) {
      sendUnauthorized(res);
      return;
    }
    const discountPolicyId = req.params.id;
    try {
      const discountPolicy =
        await this.discountPolicyService.deleteDisCountPolicy(
          discountPolicyId,
          actorId,
          userRole
        );

      sendSuccess(res, discountPolicy, "Xóa chính sách thành công ");
    } catch (error) {
      console.log(
        chalk.red("[Discount Policy] Error deletting discount policy: ", error)
      );
      return next(error);
    }
  }
}

export default DiscountPolicyController;
