import { Request, Response, NextFunction } from "express";
import chalk from "chalk";
import { SchoolAdminService } from "../../services";
import {
  sendNotFound,
  sendSuccess,
  sendUnauthorized,
  sendEmpty,
  sendBadRequest,
} from "../../../common/utils/ResponseHelper";
import { SchoolAdminPositionEnum } from "../../../common/enum/schoolAdmin.enum";

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

      sendSuccess(res, schoolAdmins, "Lấy danh sách school Admins thành công");
    } catch (error) {
      console.log(
        chalk.red("[SCHOOL_ADMIN] Error getting all school admins:", error)
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

      sendSuccess(res, schoolAdmin, "Lấy school Admins theo ID thành công");
    } catch (error) {
      console.log(
        chalk.red("[SCHOOL_ADMIN] Error getting school admins by ID:", error)
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

      sendSuccess(res, schoolAdmin, "Thêm mới school Admin thành công");
    } catch (error) {
      console.log(
        chalk.red("[SCHOOL_ADMIN] Error creatting school admin:", error)
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

      sendSuccess(res, schoolAdmin, "Cập nhật school Admin thành công");
    } catch (error) {
      console.log(
        chalk.red("[SCHOOL_ADMIN] Error updating school admin:", error)
      );
      return next(error);
    }
  }

  async updatePositionSchoolAdmin(
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

    const schoolAdminId = req.params.id;
    const { position } = req.body;

    if (!schoolAdminId || !position) {
      sendBadRequest(res, "Thiếu thông tin người dùng và vị trí cần cập nhật");
      return;
    }

    try {
      const schoolAdmin =
        await this.schoolAdminService.updatePositionSchoolAdmin(
          actorId,
          userRole,
          schoolAdminId,
          position
        );

      sendSuccess(
        res,
        { position: schoolAdmin?.position },
        "Cập nhật school Admin thành công"
      );
    } catch (error) {
      console.log(
        chalk.red("[SCHOOL_ADMIN] Error updating position school admin:", error)
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

      sendSuccess(res, schoolAdmin, "Xóa school Admin thành công");
    } catch (error) {
      console.log(
        chalk.red("[SCHOOL_ADMIN] Error deletting school admin:", error)
      );
      return next(error);
    }
  }
}

export default SchoolAdminController;
