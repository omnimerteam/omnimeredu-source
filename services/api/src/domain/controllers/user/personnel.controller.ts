import { NextFunction } from "express-serve-static-core";
import { Request, Response } from "express";
import chalk from "chalk";

import { PersonnelService } from "../../services";
import {
  sendUnauthorized,
  sendSuccess,
  sendEmpty,
  sendBadRequest,
  sendNoContent,
} from "../../../common/utils/ResponseHelper";
import { buildQueryOptions } from "../../../common/utils/buildQueryOptions";
class PersonnelController {
  private personnelService: PersonnelService;
  constructor(personnelService: PersonnelService) {
    this.personnelService = personnelService;
  }

  async getAllPersonnel(
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
      const personnel = await this.personnelService.getAllPersonnel(
        actorId,
        userRole,
        schoolId,
        options
      );
      if (!personnel || personnel.length === 0) {
        sendEmpty(res);
        return;
      }

      sendSuccess(res, personnel, "Lấy thông tin tất cả thành viên thành công");
      return;
    } catch (error) {
      console.error(
        chalk.red("[PERSONNEL] Error getting all personnel:", error)
      );
      return next(error);
    }
  }

  async updateRoleId(
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

    const id = req.params.id;
    const { roleId } = req.body;

    if (!id) {
      sendBadRequest(res, "Bạn chưa chọn nhân sự");
      return;
    }

    if (!roleId) {
      sendBadRequest(res, "Bạn chưa chọn vai trò để cập nhật");
      return;
    }

    try {
      const updatePersonnel = await this.personnelService.updateRoleId(
        actorId,
        userRole,
        id,
        roleId
      );

      sendSuccess(
        res,
        {
          roleId: updatePersonnel?.roleId,
          roleKey: updatePersonnel?.roleKey,
        },
        "Cập nhật vai trò cho nhân sự thành công"
      );
      return;
    } catch (error) {
      console.error(
        chalk.red("[PERSONNEL] Error updating roleId for personnel:", error)
      );
      return next(error);
    }
  }

  async updateVerified(
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

    const id = req.params.id;
    const { isVerified } = req.body;

    if (!id) {
      sendBadRequest(res, "Bạn chưa chọn nhân sự");
      return;
    }

    if (isVerified == null) {
      sendBadRequest(res, "Bạn chưa chọn đình chỉ hay khôi phục công tác");
      return;
    }

    try {
      const updatePersonnel = await this.personnelService.updateVerified(
        actorId,
        userRole,
        id,
        isVerified
      );

      sendSuccess(
        res,
        {
          isVerified: updatePersonnel?.isVerified,
        },
        isVerified == true
          ? "Khôi phục công tác thành công"
          : "Đình chỉ công tác thành công"
      );
      return;
    } catch (error) {
      console.error(
        chalk.red("[PERSONNEL] Error updating verified for personnel:", error)
      );
      return next(error);
    }
  }

  async dismissPersonnel(
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

    const id = req.params.id;

    if (!id) {
      sendBadRequest(res, "Bạn chưa chọn nhân sự");
      return;
    }

    try {
      const updatePersonnel = await this.personnelService.dismissPersonnel(
        actorId,
        userRole,
        id
      );

      sendEmpty(res, `Đã duổi ${updatePersonnel?.fullName}`);
      return;
    } catch (error) {
      console.error(
        chalk.red("[PERSONNEL] Error dismiss for personnel:", error)
      );
      return next(error);
    }
  }
}
export default PersonnelController;
