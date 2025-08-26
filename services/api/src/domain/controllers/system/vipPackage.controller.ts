import { NextFunction } from "express-serve-static-core";
import { IVipPackage } from "../../models";
import { Request, Response } from "express";
import chalk from "chalk";

import { VipPackageService } from "../../services";
import {
  sendUnauthorized,
  sendSuccess,
  sendNotFound,
  sendEmpty,
} from "../../../common/utils/ResponseHelper";
import { buildQueryOptions } from "../../../common/utils/buildQueryOptions";
class VipPackageController {
  private readonly vipPackageService: VipPackageService;

  constructor(vipPackageService: VipPackageService) {
    this.vipPackageService = vipPackageService;
  }

  async getAllVipPackages(
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

    const options = buildQueryOptions(req.query as any);

    try {
      const vipPackages = await this.vipPackageService.getAllVipPackages(
        actorId,
        userRole,
        options
      );
      if (!vipPackages || vipPackages.length === 0) {
        sendEmpty(res);
        return;
      }

      sendSuccess(res, vipPackages, "Lấy danh sách gói thành viên thành công");
      return;
    } catch (error) {
      console.error(
        chalk.red("[VIPPACKAGES] Error getting all vipPackages:", error)
      );
      return next(error);
    }
  }
  async getVipPackageById(
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
    const vipPackageId = req.params.id;

    try {
      const vipPackage = await this.vipPackageService.getVipPackageById(
        vipPackageId,
        actorId,
        userRole
      );
      if (!vipPackage) {
        sendNotFound(res);
        return;
      }

      sendSuccess(
        res,
        vipPackage,
        "Lấy thông tin gói thành viên từ ID thành công"
      );
      return;
    } catch (error) {
      console.error(
        chalk.red("[VIPPACKAGES] Error getting vipPackage by ID", error)
      );
      return next(error);
    }
  }
  async createVipPackage(
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
    const vipPackageData = req.body;

    try {
      const newVipPackage = await this.vipPackageService.createVipPackage(
        vipPackageData,
        actorId,
        userRole
      );

      sendSuccess(res, newVipPackage, "Tạo mới gói thành viên mới thành công");
      return;
    } catch (error) {
      console.log(
        chalk.red("[VIPPACKAGES] Error creatting new vipPackage:", error)
      );
      return next(error);
    }
  }

  async updateVipPackage(
    req: Request,
    res: Response,
    next: NextFunction
  ): Promise<void> {
    try {
      const actorId = req.user?.id;
      const userRole = req.role;
      if (!userRole || !actorId) {
        sendUnauthorized(res);
        return;
      }
      const vipPackageId = req.params.id;
      if (!vipPackageId) {
        sendNotFound(res);
        return;
      }
      const vipPackageData: Partial<IVipPackage> = req.body;
      const updatedVipPackage = await this.vipPackageService.updateVipPackage(
        vipPackageId,
        vipPackageData,
        actorId,
        userRole
      );

      sendSuccess(
        res,
        updatedVipPackage,
        "Cập nhật thông tin gói thành viên thành công"
      );
      return;
    } catch (error) {
      console.log(chalk.red("[VIPPACKAGES] Error updating vipPackage:", error));
      return next(error);
    }
  }

  async deleteVipPackage(
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

    const vipPackageId = req.params.id;
    if (!vipPackageId) {
      sendNotFound(res);
      return;
    }

    try {
      const deletedVipPackage = await this.vipPackageService.deleteVipPackage(
        vipPackageId,
        actorId,
        userRole
      );

      sendSuccess(
        res,
        deletedVipPackage,
        "Xóa thông tin gói thành viên thành công"
      );
      return;
    } catch (error) {
      console.log(chalk.red("[VIPPACKAGES] Error delete vipPackage:", error));
      return next(error);
    }
  }
}

export default VipPackageController;
