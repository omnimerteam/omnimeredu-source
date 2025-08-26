import { NextFunction } from "express-serve-static-core";
import { ITeacher } from "../../models";
import { Request, Response } from "express";
import chalk from "chalk";

import { TeacherService } from "../../services";
import {
  sendUnauthorized,
  sendSuccess,
  sendNotFound,
  sendEmpty,
} from "../../../common/utils/ResponseHelper";
class TeacherController {
  private teacherService: TeacherService;
  constructor(teacherService: TeacherService) {
    this.teacherService = teacherService;
  }

  async getAllTeachers(
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
      const teachers = await this.teacherService.getAllTeachers(
        actorId,
        userRole
      );
      if (!teachers || teachers.length === 0) {
        sendEmpty(res);
        return;
      }
      console.log(chalk.green("[TEACHER] Get all teachers successfully"));
      sendSuccess(res, teachers, "Lấy thông tin tất cả giáo viên thành công");
      return;
    } catch (error) {
      console.error(chalk.red("[TEACHER] Error getting all teachers:", error));
      return next(error);
    }
  }
  async getTeacherById(
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
      const teacherId = req.params.id;
      const teacher = await this.teacherService.getTeacherById(
        teacherId,
        actorId,
        userRole
      );
      if (!teacher) {
        sendNotFound(res);
        return;
      }
      console.log(
        chalk.green(`[TEACHER] Get teacher by ${teacherId} successfully`)
      );
      sendSuccess(res, teacher, "Lấy thông tin giáo viên từ ID thành công");
      return;
    } catch (error) {
      console.error(chalk.red("[TEACHER] Error getting teacher by ID", error));
      return next(error);
    }
  }
  async createTeacher(
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
      const teacherData = req.body;
      const createdTeacher = await this.teacherService.createTeacher(
        teacherData,
        actorId,
        userRole
      );
      console.log(chalk.green("[TEACHER] Create new teacher successfully"));
      sendSuccess(res, createdTeacher, "Thêm mới giáo viên thành công");
      return;
    } catch (error) {
      console.log(chalk.red("[TEACHER] Error creatting new teacher:", error));
      return next(error);
    }
  }

  async updateTeacher(
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
      const teacherId = req.params.id;
      if (!teacherId) {
        sendNotFound(res);
        return;
      }
      const teacherData: Partial<ITeacher> = req.body;
      const updateTeacher = await this.teacherService.updateTeacher(
        teacherId,
        teacherData,
        actorId,
        userRole
      );

      console.log(chalk.green("[TEACHER] Update teacher successfully"));
      sendSuccess(
        res,
        updateTeacher,
        "Cập nhật thông tin giáo viên thành công"
      );
      return;
    } catch (error) {
      console.log(chalk.red("[TEACHER] Error updatting teacher:", error));
      return next(error);
    }
  }

  async deleteTeacher(
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
      const teacherId = req.params.id;
      if (!teacherId) {
        sendNotFound(res);
        return;
      }

      const deleteTeacher = await this.teacherService.deleteTeacher(
        teacherId,
        actorId,
        userRole
      );

      console.log(chalk.green("[TEACHER] Delete teacher successfully"));
      sendSuccess(res, deleteTeacher, "Xóa giáo viên thành công");
      return;
    } catch (error) {
      console.log(chalk.red("[TEACHER] Error delete teacher:", error));
      return next(error);
    }
  }
}
export default TeacherController;
