import { Request, Response, NextFunction } from "express";
import chalk from "chalk";
import { SchoolAdminService } from "../../services";
import {
  sendNotFound,
  sendSuccess,
  sendUnauthorized,
  sendEmpty,
} from "../../../common/utils/ResponseHelper";

class SchoolAdminController {
  private readonly schoolAdminService: SchoolAdminService;
  constructor(schoolAdminService: SchoolAdminService) {
    this.schoolAdminService = schoolAdminService;
  }

  async getAllSchoolAdmins(
    req: Request,
    res: Response,
    next: NextFunction
  ): Promise<void> {
    try {
      const actorId = req.user?.id;
      const userRole = req.role;
      if (!actorId || !userRole) {
        sendUnauthorized(res);
        return;
      }
      const schoolAdmins = await this.schoolAdminService.getAllSchoolAdmins(
        actorId,
        userRole
      );
      if (!schoolAdmins) {
        sendEmpty(res);
        return;
      }
      console.log(
        chalk.green("[School Admins] Get all school admins successfully")
      );
      sendSuccess(res, schoolAdmins, "Lấy danh sách school Admins thành công");
    } catch (error) {
      console.log(
        chalk.red("[School Admins] Error getting all school admins:", error)
      );
      return next(error);
    }
  }

  async getSchoolAdminById(
    req: Request,
    res: Response,
    next: NextFunction
  ): Promise<void> {
    try {
      const actorId = req.user?.id;
      const userRole = req.role;
      if (!actorId || !userRole) {
        sendUnauthorized(res);
        return;
      }
      const schoolAdminId = req.params.id;
      const schoolAdmin = await this.schoolAdminService.getSchoolAdminById(
        schoolAdminId,
        actorId,
        userRole
      );
      if (!schoolAdmin) {
        sendNotFound(res);
        return;
      }
      console.log(
        chalk.green("[School Admins] Get school admins by ID successfully")
      );
      sendSuccess(res, schoolAdmin, "Lấy school Admins theo ID thành công");
    } catch (error) {
      console.log(
        chalk.red("[School Admins] Error getting school admins by ID:", error)
      );
      return next(error);
    }
  }

  async createSchoolAdmin(
    req: Request,
    res: Response,
    next: NextFunction
  ): Promise<void> {
    try {
      const actorId = req.user?.id;
      const userRole = req.role;
      if (!actorId || !userRole) {
        sendUnauthorized(res);
        return;
      }
      const schoolAdminData = req.body;
      const schoolAdmin = await this.schoolAdminService.createSchoolAdmin(
        schoolAdminData,
        actorId,
        userRole
      );
      console.log(
        chalk.green("[School Admins] Create school admin successfully")
      );
      sendSuccess(res, schoolAdmin, "Thêm mới school Admin thành công");
    } catch (error) {
      console.log(
        chalk.red("[School Admins] Error creatting school admin:", error)
      );
      return next(error);
    }
  }

  async updateSchoolAdmin(
    req: Request,
    res: Response,
    next: NextFunction
  ): Promise<void> {
    try {
      const actorId = req.user?.id;
      const userRole = req.role;
      if (!actorId || !userRole) {
        sendUnauthorized(res);
        return;
      }
      const schoolAdminId = req.params.id;
      const schoolAdminData = req.body;
      const schoolAdmin = await this.schoolAdminService.updateSchoolAdmin(
        schoolAdminId,
        schoolAdminData,
        actorId,
        userRole
      );
      console.log(
        chalk.green("[School Admins] Update school admin successfully")
      );
      sendSuccess(res, schoolAdmin, "Cập nhật school Admin thành công");
    } catch (error) {
      console.log(
        chalk.red("[School Admins] Error updating school admin:", error)
      );
      return next(error);
    }
  }

  async deleteSchoolAdmin(
    req: Request,
    res: Response,
    next: NextFunction
  ): Promise<void> {
    try {
      const actorId = req.user?.id;
      const userRole = req.role;
      if (!actorId || !userRole) {
        sendUnauthorized(res);
        return;
      }
      const schoolAdminId = req.params.id;
      const schoolAdmin = await this.schoolAdminService.deleteSchoolAdmin(
        schoolAdminId,
        actorId,
        userRole
      );
      console.log(
        chalk.green("[School Admins] Delete school admin successfully")
      );
      sendSuccess(res, schoolAdmin, "Xóa school Admin thành công");
    } catch (error) {
      console.log(
        chalk.red("[School Admins] Error deletting school admin:", error)
      );
      return next(error);
    }
  }
}

export default SchoolAdminController;
