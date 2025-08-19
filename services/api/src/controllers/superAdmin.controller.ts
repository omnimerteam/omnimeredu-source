import { NextFunction } from "express-serve-static-core";
import { ISuperAdmin } from "../models";
import { Request, Response } from "express";
import chalk from "chalk";

import SuperAdminService from "../services/superAdmin.service";
import {
  sendUnauthorized,
  sendSuccess,
  sendNotFound,
  sendEmpty,
} from "../utils/ResponseHelper";
import { buildQueryOptions } from "../utils/buildQueryOptions";
class SuperAdminController {
  private readonly superAdminService: SuperAdminService;

  constructor(superAdminService: SuperAdminService) {
    this.superAdminService = superAdminService;
  }

  async getAllSuperAdmins(
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
      const superAdmins = await this.superAdminService.getAllSuperAdmin(
        actorId,
        userRole,
        options
      );
      if (!superAdmins || superAdmins.length === 0) {
        sendEmpty(res);
        return;
      }

      sendSuccess(res, superAdmins, "Lấy danh sách admin thành công");
      return;
    } catch (error) {
      console.error(
        chalk.red("[SUPER_ADMINS] Error getting all superAdmins:", error)
      );
      return next(error);
    }
  }
  async getSuperAdminById(
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
    const superAdminId = req.params.id;

    try {
      const superAdmin = await this.superAdminService.getSuperAdminById(
        superAdminId,
        actorId,
        userRole
      );
      if (!superAdmin) {
        sendNotFound(res);
        return;
      }

      sendSuccess(res, superAdmin, "Lấy thông tin admin từ ID thành công");
      return;
    } catch (error) {
      console.error(
        chalk.red("[SUPER_ADMINS] Error getting superAdmin by ID", error)
      );
      return next(error);
    }
  }
  async createSuperAdmin(
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
    const superAdminData = req.body;

    try {
      const createdSuperAdmin = await this.superAdminService.createSuperAdmin(
        superAdminData,
        actorId,
        userRole
      );

      sendSuccess(res, createdSuperAdmin, "Tạo quản trị viên mới thành công");
      return;
    } catch (error) {
      console.log(
        chalk.red("[SUPER_ADMINS] Error creatting new superAdmin:", error)
      );
      return next(error);
    }
  }

  async updateSuperAdmin(
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
      const superAdminId = req.params.id;
      if (!superAdminId) {
        sendNotFound(res);
        return;
      }
      const superAdminData: Partial<ISuperAdmin> = req.body;
      const updateSuperAdmin = await this.superAdminService.updateSuperAdmin(
        superAdminId,
        superAdminData,
        actorId,
        userRole
      );

      sendSuccess(
        res,
        updateSuperAdmin,
        "Cập nhật thông tin giáo viên thành công"
      );
      return;
    } catch (error) {
      console.log(
        chalk.red("[SUPER_ADMINS] Error updatting superAdmin:", error)
      );
      return next(error);
    }
  }

  async deleteSuperAdmin(
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

    const superAdminId = req.params.id;
    if (!superAdminId) {
      sendNotFound(res);
      return;
    }

    try {
      const deleteSuperAdmin = await this.superAdminService.deleteSuperAdmin(
        superAdminId,
        actorId,
        userRole
      );

      sendSuccess(res, deleteSuperAdmin, "Xóa giáo viên thành công");
      return;
    } catch (error) {
      console.log(chalk.red("[SUPER_ADMINS] Error delete superAdmin:", error));
      return next(error);
    }
  }
}
export default SuperAdminController;
