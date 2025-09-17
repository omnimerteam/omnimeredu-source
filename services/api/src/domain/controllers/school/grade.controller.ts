import { NextFunction, Request, Response } from "express";
import chalk from "chalk";
import { IGrade } from "../../models";
import { GradeService } from "../../services";
import {
  sendUnauthorized,
  sendSuccess,
  sendNotFound,
  sendEmpty,
} from "../../../common/utils/ResponseHelper";
import { buildQueryOptions } from "../../../common/utils/buildQueryOptions";

class GradeController {
  private readonly gradeService: GradeService;

  constructor(gradeService: GradeService) {
    this.gradeService = gradeService;
  }

  // 🔹 Lấy tất cả khối
  async getAllGrades(req: Request, res: Response, next: NextFunction) {
    const actorId = req.user?.id;
    const userRole = req.role;
    if (!actorId || !userRole) {
      sendUnauthorized(res);
      return;
    }

    const schoolId = req.query.schoolId as string | undefined;
    const options = buildQueryOptions(req.query as any);

    try {
      const grades = await this.gradeService.getAllGrades(
        actorId,
        userRole,
        schoolId,
        options
      );

      if (!grades || grades.length === 0) {
        sendEmpty(res);
        return;
      }

      sendSuccess(res, grades, "Lấy danh sách khối thành công");
    } catch (error) {
      console.error(chalk.red("[GRADES] Error getting all grades:", error));
      return next(error);
    }
  }

  // 🔹 Lấy khối theo ID
  async getGradeById(req: Request, res: Response, next: NextFunction) {
    const actorId = req.user?.id;
    const userRole = req.role;
    if (!actorId || !userRole) {
      sendUnauthorized(res);
      return;
    }

    const gradeId = req.params.id;
    if (!gradeId) {
      sendNotFound(res);
      return;
    }

    try {
      const grade = await this.gradeService.getGradeById(
        gradeId,
        actorId,
        userRole
      );

      if (!grade) {
        sendNotFound(res);
        return;
      }

      sendSuccess(res, grade, "Lấy thông tin khối theo ID thành công");
    } catch (error) {
      console.error(chalk.red("[GRADES] Error getting grade by ID:", error));
      return next(error);
    }
  }

  // 🔹 Tạo mới khối
  async createGrade(req: Request, res: Response, next: NextFunction) {
    const actorId = req.user?.id;
    const userRole = req.role;
    const schoolId = req.user?.schoolId;
    if (!actorId || !userRole) {
      sendUnauthorized(res);
      return;
    }

    const gradeData: Partial<IGrade> = req.body;

    try {
      const newGrade = await this.gradeService.createGrade(
        { ...gradeData, schoolId: schoolId },
        actorId,
        userRole
      );

      sendSuccess(res, newGrade, "Tạo mới khối thành công");
    } catch (error) {
      console.error(chalk.red("[GRADES] Error creating grade:", error));
      return next(error);
    }
  }

  // 🔹 Cập nhật khối
  async updateGrade(req: Request, res: Response, next: NextFunction) {
    const actorId = req.user?.id;
    const userRole = req.role;
    if (!actorId || !userRole) {
      sendUnauthorized(res);
      return;
    }

    const gradeId = req.params.id;
    if (!gradeId) {
      sendNotFound(res);
      return;
    }

    const gradeData: Partial<IGrade> = req.body;

    try {
      const updatedGrade = await this.gradeService.updateGrade(
        gradeId,
        gradeData,
        actorId,
        userRole
      );

      sendSuccess(res, updatedGrade, "Cập nhật thông tin khối thành công");
    } catch (error) {
      console.error(chalk.red("[GRADES] Error updating grade:", error));
      return next(error);
    }
  }

  // 🔹 Xoá khối
  async deleteGrade(req: Request, res: Response, next: NextFunction) {
    const actorId = req.user?.id;
    const userRole = req.role;
    if (!actorId || !userRole) {
      sendUnauthorized(res);
      return;
    }

    const gradeId = req.params.id;
    if (!gradeId) {
      sendNotFound(res);
      return;
    }

    try {
      const deletedGrade = await this.gradeService.deleteGrade(
        gradeId,
        actorId,
        userRole
      );

      sendSuccess(res, deletedGrade, "Xóa khối thành công");
    } catch (error) {
      console.error(chalk.red("[GRADES] Error deleting grade:", error));
      return next(error);
    }
  }

  // 🔹 Lấy danh sách khối cho selectbox
  async getGradesForSelect(req: Request, res: Response, next: NextFunction) {
    const actorId = req.user?.id;
    const userRole = req.role;
    const schoolId = req.user?.schoolId;
    if (!actorId || !userRole) {
      sendUnauthorized(res);
      return;
    }

    try {
      const grades = await this.gradeService.getGradesForSelect(
        actorId,
        userRole,
        schoolId
      );

      if (!grades || grades.length === 0) {
        sendEmpty(res);
        return;
      }

      sendSuccess(res, grades, "Lấy danh sách khối cho selectbox thành công");
    } catch (error) {
      console.error(
        chalk.red("[GRADES] Error getting grades for select:", error)
      );
      return next(error);
    }
  }
}

export default GradeController;
