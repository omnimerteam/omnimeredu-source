import { NextFunction } from "express-serve-static-core";
import { Request, Response } from "express";
import chalk from "chalk";

import { PersonnelService } from "../../services";
import {
  sendUnauthorized,
  sendSuccess,
  sendEmpty,
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
      console.error(chalk.red("[TEACHER] Error getting all personnel:", error));
      return next(error);
    }
  }
}
export default PersonnelController;
