import { Request, Response, NextFunction } from "express";
import { AttendanceService } from "../../../services";
import chalk from "chalk";
import {
  sendSuccess,
  sendNotFound,
  sendEmpty,
  sendUnauthorized,
  sendError,
  sendExcelResponse,
  ExcelMode,
} from "../../../../common/utils/ResponseHelper";
import { buildQueryOptions } from "../../../../common/utils/buildQueryOptions";

class AttendanceController {
  private readonly attendanceService: AttendanceService;
  constructor(attendanceService: AttendanceService) {
    this.attendanceService = attendanceService;
  }
  async getAllAttendances(
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
    const actorSchoolId = req.user?.schoolId?.toString();
    const options = buildQueryOptions(req.query as any);

    try {
      const attendances = await this.attendanceService.getAllAttendances(
        actorId,
        userRole,
        actorSchoolId,
        options
      );
      if (!attendances || attendances.length === 0) {
        sendEmpty(res);
        return;
      }
      sendSuccess(res, attendances, "Lấy tất cả attendances thành công");
      return;
    } catch (error) {
      console.log(
        chalk.red("[Attendance] Error getting all attendances:", error)
      );
      return next(error);
    }
  }
  async getAttendanceById(
    req: Request,
    res: Response,
    next: NextFunction
  ): Promise<void> {
    try {
      const actorId = req.user?.id;
      const actorSchoolId = req.user?.schoolId?.toString();
      const userRole = req.role;

      if (!actorId || !userRole) {
        sendUnauthorized(res);
        return;
      }
      const attendanceId = req.params.id;
      const attendance = await this.attendanceService.getAttendanceById(
        attendanceId,
        actorSchoolId,
        actorId,
        userRole
      );
      if (!attendance) {
        sendNotFound(res);
        return;
      }
      sendSuccess(res, attendance, "Lấy bảng điểm danh thành công");
      return;
    } catch (error) {
      console.log(
        chalk.red("[Attendance] Error getting attendance by ID:", error)
      );
      return next(error);
    }
  }

  async getAttendanceRecordViewById(
    req: Request,
    res: Response,
    next: NextFunction
  ): Promise<void> {
    try {
      const actorId = req.user?.id;
      const actorSchoolId = req.user?.schoolId;
      const userRole = req.role;

      if (!actorId || !userRole) {
        sendUnauthorized(res);
        return;
      }

      const attendanceId = req.params.id;
      const attendance =
        await this.attendanceService.getAttendanceRecordViewById(
          attendanceId,
          actorSchoolId,
          actorId,
          userRole
        );
      if (!attendance) {
        sendNotFound(res);
        return;
      }
      sendSuccess(res, attendance, "Lấy bảng điểm danh thành công");
      return;
    } catch (error) {
      console.log(
        chalk.red("[Attendance] Error getting attendance by ID:", error)
      );
      return next(error);
    }
  }

  async getClassAttendanceRecordView(
    req: Request,
    res: Response,
    next: NextFunction
  ): Promise<void> {
    const actorId = req.user?.id;
    const actorSchoolId = req.user?.schoolId;
    const userRole = req.role;
    if (!actorId || !userRole) {
      sendUnauthorized(res);
      return;
    }
    const classId = req.query.classId as string;
    const date = req.query.date as Date | undefined;
    try {
      const attendance =
        await this.attendanceService.getClassAttendanceRecordView(
          classId,
          actorId,
          actorSchoolId,
          userRole,
          date ? new Date(date) : new Date()
        );

      if (!attendance) {
        sendEmpty(res, "Không tìm thấy bảng điểm danh cho lớp này");
        return;
      }

      sendSuccess(res, attendance, "Lấy bảng điểm danh thành công");
    } catch (error) {
      console.log(
        chalk.red("[Attendance] Error getting attendances by class ID:", error)
      );
      return next(error);
    }
  }

  async createAttendance(
    req: Request,
    res: Response,
    next: NextFunction
  ): Promise<void> {
    try {
      const actorId = req.user?.id;
      const userRole = req.role;
      const actorSchoolId = req.user?.schoolId?.toString();

      if (!actorId || !userRole) {
        sendUnauthorized(res);
        return;
      }

      if (!actorSchoolId) {
        sendError(res, "Người dùng chưa tham gia trường nào", 400);
      }

      const attendanceData = req.body;
      const attendance = await this.attendanceService.createAttendance(
        attendanceData,
        actorSchoolId,
        actorId,
        userRole
      );
      if (!attendance) {
        sendNotFound(res);
        return;
      }
      console.log(chalk.green("[Attendance] Create attendance successfully"));
      sendSuccess(res, attendance, "Tạo attendance thành công");
      return;
    } catch (error) {
      console.log(chalk.red("[Attendance] Error creatting attendance:", error));
      return next(error);
    }
  }

  async initializeClassAttendance(
    req: Request,
    res: Response,
    next: NextFunction
  ): Promise<void> {
    try {
      const actorId = req.user?.id;
      const userRole = req.role;
      const actorSchoolId = req.user?.schoolId;

      if (!actorId || !userRole) {
        sendUnauthorized(res);
        return;
      }

      const attendanceData = req.body;

      const attendance = await this.attendanceService.initializeClassAttendance(
        attendanceData,
        actorSchoolId,
        actorId,
        userRole
      );

      sendSuccess(res, attendance, "Tạo attendance thành công");
      return;
    } catch (error) {
      console.log(chalk.red("[Attendance] Error creatting attendance:", error));
      return next(error);
    }
  }

  async updateAttendance(
    req: Request,
    res: Response,
    next: NextFunction
  ): Promise<void> {
    try {
      const actorId = req.user?.id;
      const actorSchoolId = req.user?.schoolId?.toString();
      const userRole = req.role;
      if (!actorId || !userRole) {
        sendUnauthorized(res);
        return;
      }
      const attendanceId = req.params.id;
      const attendanceData = req.body;
      const attendance = await this.attendanceService.updateAttendance(
        attendanceId,
        attendanceData,
        actorId,
        actorSchoolId,
        userRole
      );
      if (!attendance) {
        sendNotFound(res);
        return;
      }
      console.log(chalk.green("[Attendance] Update attendance successfully"));
      sendSuccess(res, attendance, "Cập nhật attendance thành công");
      return;
    } catch (error) {
      console.log(chalk.red("[Attendance] Error updatting attendance:", error));
      return next(error);
    }
  }

  async deleteAttendance(
    req: Request,
    res: Response,
    next: NextFunction
  ): Promise<void> {
    try {
      const actorId = req.user?.id;
      const actorSchoolId = req.user?.schoolId?.toString();
      const userRole = req.role;
      if (!actorId || !userRole) {
        sendUnauthorized(res);
        return;
      }
      const attendanceId = req.params.id;
      const attendance = await this.attendanceService.deleteAttendance(
        attendanceId,
        actorId,
        actorSchoolId,
        userRole
      );
      if (!attendance) {
        sendNotFound(res);
        return;
      }

      sendSuccess(res, attendance, "Xoas attendance thành công");
      return;
    } catch (error) {
      console.log(chalk.red("[Attendance] Error Deletting attendance:", error));
      return next(error);
    }
  }
  /**
   * Xuất file Excel điểm danh (tải xuống hoặc trả JSON base64)
   */
  async exportAttendanceExcel(
    req: Request,
    res: Response,
    next: NextFunction
  ): Promise<void> {
    try {
      const actorId = req.user?.id;
      if (!actorId) {
        sendUnauthorized(res);
        return;
      }

      const attendanceId = req.params.id;
      const mode = (req.query.mode as ExcelMode) || ExcelMode.download;

      const buffer = await this.attendanceService.exportAttendanceExcel(
        actorId,
        attendanceId
      );

      if (!buffer) {
        sendNotFound(res, "Không tìm thấy bản ghi điểm danh");
        return;
      }

      sendExcelResponse(
        res,
        buffer,
        `attendance_${attendanceId}.xlsx`,
        mode,
        "Xuất file điểm danh thành công"
      );
    } catch (error) {
      console.log(chalk.red("[Attendance] Error exporting attendance:", error));
      next(error);
    }
  }
}
export default AttendanceController;
