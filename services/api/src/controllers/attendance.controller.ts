import { Request, Response, NextFunction } from "express";
import AttendanceService from "../services/attendance.service";
import chalk from "chalk";
import {
  sendSuccess,
  sendNotFound,
  sendEmpty,
  sendUnauthorized,
  sendError,
} from "../utils/ResponseHelper";

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
    try {
      const actorId = req.user?.id;
      const userRole = req.role;
      if (!actorId || !userRole) {
        sendUnauthorized(res);
        return;
      }
      const attendances = await this.attendanceService.getAllAttendances(
        actorId,
        userRole
      );
      if (!attendances || attendances.length === 0) {
        sendEmpty(res);
        return;
      }
      console.log(chalk.green("[Attendance] Get all attendances successfully"));
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
      console.log(
        chalk.green("[Attendance] Get attendance by ID successfully")
      );
      sendSuccess(res, attendance, "Lấy attendance bằng ID thành công");
      return;
    } catch (error) {
      console.log(
        chalk.red("[Attendance] Error getting attendance by ID:", error)
      );
      return next(error);
    }
  }

  async getAttendancesBySchoolId(
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

      if (!actorSchoolId) {
        sendError(res, "Người dùng chưa tham gia trường nào", 400);
      }

      const schoolId = req.params.schoolId;
      const attendances = await this.attendanceService.getAttendancesBySchoolId(
        schoolId,
        actorSchoolId,
        actorId,
        userRole
      );
      if (!attendances || attendances.length === 0) {
        sendEmpty(res);
        return;
      }
      console.log(
        chalk.green("[Attendance] Get attendances by school ID successfully")
      );
      sendSuccess(
        res,
        attendances,
        "Lấy tất cả attendances theo school ID thành công"
      );
    } catch (error) {
      console.log(
        chalk.red("[Attendance] Error getting attendances by school ID:", error)
      );
      return next(error);
    }
  }

  async getAttendancesByClassId(
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
      const classId = req.params.classId;
      const attendances = await this.attendanceService.getAttendancesByClassId(
        classId,
        actorId,
        actorSchoolId,
        userRole
      );
      if (!attendances || attendances.length === 0) {
        sendEmpty(res);
        return;
      }
      console.log(
        chalk.green("[Attendance] Get attendances by class ID successfully")
      );
      sendSuccess(
        res,
        attendances,
        "Lấy tất cả attendances theo class ID thành công"
      );
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
      console.log(chalk.green("[Attendance] Delete attendance successfully"));
      sendSuccess(res, attendance, "Xoas attendance thành công");
      return;
    } catch (error) {
      console.log(chalk.red("[Attendance] Error Deletting attendance:", error));
      return next(error);
    }
  }
}
export default AttendanceController;
