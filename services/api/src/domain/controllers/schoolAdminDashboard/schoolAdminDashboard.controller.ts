import { NextFunction, Request, Response } from "express";
import { SchoolAdminDashboardService } from "../../services";
import {
  sendBadRequest,
  sendSuccess,
  sendUnauthorized,
} from "../../../common/utils/ResponseHelper";
import chalk from "chalk";

class SchoolAdminDashboardController {
  private readonly schoolAdminDashboardService: SchoolAdminDashboardService;

  constructor(schoolAdminDashboardService: SchoolAdminDashboardService) {
    this.schoolAdminDashboardService = schoolAdminDashboardService;
  }

  /**
   * Lấy danh sách các bài đăng theo trường
   * @param req : user, roles, params.schoolId
   * @param res : schoolNews
   * @param next : error
   * @returns
   */
  async getSummary(
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

    try {
      const result = await this.schoolAdminDashboardService.getSummary(
        actorId,
        userRole,
        schoolId
      );

      sendSuccess(res, result, "Lấy thông tin tổng quan thành công");
      return;
    } catch (error) {
      console.log(
        chalk.red("[SCHOOL_ADMIN_DASHBOARD] ❌ Get summary failed"),
        error
      );
      return next(error);
    }
  }

  async getSchoolAttendanceStats(
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

    if (!schoolId) {
      sendBadRequest(res, "Người dùng chưa được gán trường học");
      return;
    }

    // parse date từ query (nếu có)
    let targetDate: Date | undefined;
    if (req.query.date) {
      const parsedDate = new Date(req.query.date as string);
      if (!isNaN(parsedDate.getTime())) {
        targetDate = parsedDate;
      } else {
        sendBadRequest(res, "Ngày không hợp lệ");
        return;
      }
    }

    try {
      const result =
        await this.schoolAdminDashboardService.getSchoolAttendanceStats(
          actorId,
          userRole,
          schoolId,
          targetDate
        );

      sendSuccess(res, result, "Lấy thông tin tổng quan thành công");
      return;
    } catch (error) {
      console.error(
        chalk.red(
          "[SCHOOL_ADMIN_DASHBOARD] ❌ Get School Attendance Stats failed"
        ),
        { actorId, schoolId, userRole, error }
      );
      return next(error);
    }
  }
}

export default SchoolAdminDashboardController;
