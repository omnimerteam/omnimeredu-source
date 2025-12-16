import { Request, Response } from "express";
import { EducationSystemLevelsEnum } from "shared-lib";
import { CreateGradeUseCase } from "../../domain/usecases/grade/CreateGradeUseCase";
import { GetGradeByIdUseCase } from "../../domain/usecases/grade/GetGradeByIdUseCase";
import { GetGradesBySchoolIdUseCase } from "../../domain/usecases/grade/GetGradesBySchoolIdUseCase";
import { UpdateGradeUseCase } from "../../domain/usecases/grade/UpdateGradeUseCase";
import { DeleteGradeUseCase } from "../../domain/usecases/grade/DeleteGradeUseCase";
import {
  GetAllGradesUseCase,
  PaginationOptions,
  FilterOptions,
} from "../../domain/usecases/grade/GetAllGradesUseCase";
import { GetGradesForSelectUseCase } from "../../domain/usecases/grade/GetGradesForSelectUseCase";
import { BulkGradeOperationsUseCase } from "../../domain/usecases/grade/BulkGradeOperationsUseCase";
import { GradeRepositoryImpl } from "../../data/repositories/GradeRepositoryImpl";
import { CreateGradeDto } from "../dtos/CreateGradeDto";
import { UpdateGradeDto } from "../dtos/UpdateGradeDto";
import { ResponseUtil } from "../../infrastructure/utils/ResponseUtil";

export class GradeController {
  private createGradeUseCase: CreateGradeUseCase;
  private getGradeByIdUseCase: GetGradeByIdUseCase;
  private getGradesBySchoolIdUseCase: GetGradesBySchoolIdUseCase;
  private updateGradeUseCase: UpdateGradeUseCase;
  private deleteGradeUseCase: DeleteGradeUseCase;
  private getAllGradesUseCase: GetAllGradesUseCase;
  private getGradesForSelectUseCase: GetGradesForSelectUseCase;
  private bulkGradeOperationsUseCase: BulkGradeOperationsUseCase;

  constructor() {
    const gradeRepository = new GradeRepositoryImpl();
    this.createGradeUseCase = new CreateGradeUseCase(gradeRepository);
    this.getGradeByIdUseCase = new GetGradeByIdUseCase(gradeRepository);
    this.getGradesBySchoolIdUseCase = new GetGradesBySchoolIdUseCase(
      gradeRepository
    );
    this.updateGradeUseCase = new UpdateGradeUseCase(gradeRepository);
    this.deleteGradeUseCase = new DeleteGradeUseCase(gradeRepository);
    this.getAllGradesUseCase = new GetAllGradesUseCase(gradeRepository);
    this.getGradesForSelectUseCase = new GetGradesForSelectUseCase(
      gradeRepository
    );
    this.bulkGradeOperationsUseCase = new BulkGradeOperationsUseCase(
      gradeRepository
    );
  }

  async createGrade(req: Request, res: Response): Promise<void> {
    try {
      const dto: CreateGradeDto = req.body;
      const grade = await this.createGradeUseCase.execute(dto);
      ResponseUtil.sendSuccess(res, "Grade created successfully", grade, 201);
    } catch (error: any) {
      ResponseUtil.sendError(res, error.message, error, 400);
    }
  }

  async getGradeById(req: Request, res: Response): Promise<void> {
    try {
      const { id } = req.params;
      const grade = await this.getGradeByIdUseCase.execute(id);
      if (!grade) {
        ResponseUtil.sendError(res, "Grade not found", null, 404);
        return;
      }
      ResponseUtil.sendSuccess(res, "Grade retrieved successfully", grade);
    } catch (error: any) {
      ResponseUtil.sendError(res, error.message, error, 400);
    }
  }

  async getGradesBySchoolId(req: Request, res: Response): Promise<void> {
    try {
      const { schoolId } = req.params;
      const grades = await this.getGradesBySchoolIdUseCase.execute(schoolId);
      ResponseUtil.sendSuccess(res, "Grades retrieved successfully", grades);
    } catch (error: any) {
      ResponseUtil.sendError(res, error.message, error, 400);
    }
  }

  async updateGrade(req: Request, res: Response): Promise<void> {
    try {
      const { id } = req.params;
      const dto: UpdateGradeDto = req.body;
      const grade = await this.updateGradeUseCase.execute(id, dto);
      ResponseUtil.sendSuccess(res, "Grade updated successfully", grade);
    } catch (error: any) {
      const statusCode = error.message === "Grade not found" ? 404 : 400;
      ResponseUtil.sendError(res, error.message, error, statusCode);
    }
  }

  async deleteGrade(req: Request, res: Response): Promise<void> {
    try {
      const { id } = req.params;
      const success = await this.deleteGradeUseCase.execute(id);
      ResponseUtil.sendSuccess(res, "Grade deleted successfully", { success });
    } catch (error: any) {
      const statusCode = error.message === "Grade not found" ? 404 : 400;
      ResponseUtil.sendError(res, error.message, error, statusCode);
    }
  }

  async getAllGrades(req: Request, res: Response): Promise<void> {
    try {
      const {
        page = 1,
        limit = 20,
        sortBy = "name",
        sortOrder = "asc",
        schoolId,
        level,
        active,
        search,
        name,
        fields, // Field selection
      } = req.query;

      // Parse fields parameter
      const selectedFields = fields ? (fields as string).split(",") : undefined;

      const options = {
        page: parseInt(page as string),
        limit: parseInt(limit as string),
        sortBy: sortBy as string,
        sortOrder: sortOrder as "asc" | "desc",
        fields: selectedFields,
        filters: {
          schoolId: schoolId as string,
          level:
            level !== undefined
              ? (level as EducationSystemLevelsEnum)
              : undefined,
          active: active !== undefined ? active === "true" : undefined,
          search: search as string,
          name: name as string,
        },
      };

      const result = await this.getAllGradesUseCase.execute(options);
      ResponseUtil.sendSuccess(res, "Grades retrieved successfully", result);
    } catch (error: any) {
      ResponseUtil.sendError(res, error.message, error, 400);
    }
  }

  async getGradesForSelect(req: Request, res: Response): Promise<void> {
    try {
      const { schoolId } = req.query;
      const grades = await this.getGradesForSelectUseCase.execute(
        schoolId as string | undefined
      );
      ResponseUtil.sendSuccess(
        res,
        "Grades for select retrieved successfully",
        grades
      );
    } catch (error: any) {
      ResponseUtil.sendError(res, error.message, error, 400);
    }
  }

  async bulkCreateGrades(req: Request, res: Response): Promise<void> {
    try {
      const grades = req.body;
      if (!Array.isArray(grades)) {
        ResponseUtil.sendError(res, "Request body must be an array", null, 400);
        return;
      }

      const result = await this.bulkGradeOperationsUseCase.bulkCreate(grades);
      ResponseUtil.sendSuccess(res, "Bulk grades operation completed", result);
    } catch (error: any) {
      ResponseUtil.sendError(res, error.message, error, 400);
    }
  }

  async bulkUpdateGrades(req: Request, res: Response): Promise<void> {
    try {
      const updates = req.body;
      if (!Array.isArray(updates)) {
        ResponseUtil.sendError(res, "Request body must be an array", null, 400);
        return;
      }

      const result = await this.bulkGradeOperationsUseCase.bulkUpdate(updates);
      ResponseUtil.sendSuccess(res, "Bulk update completed", result);
    } catch (error: any) {
      ResponseUtil.sendError(res, error.message, error, 400);
    }
  }

  async bulkDeleteGrades(req: Request, res: Response): Promise<void> {
    try {
      const { ids } = req.body;
      if (!Array.isArray(ids)) {
        ResponseUtil.sendError(res, "IDs must be an array", null, 400);
        return;
      }

      const result = await this.bulkGradeOperationsUseCase.bulkDelete(ids);
      ResponseUtil.sendSuccess(res, "Bulk delete completed", result);
    } catch (error: any) {
      ResponseUtil.sendError(res, error.message, error, 400);
    }
  }

  async bulkActivateGrades(req: Request, res: Response): Promise<void> {
    try {
      const { ids } = req.body;
      if (!Array.isArray(ids)) {
        ResponseUtil.sendError(res, "IDs must be an array", null, 400);
        return;
      }

      const result = await this.bulkGradeOperationsUseCase.bulkActivate(ids);
      ResponseUtil.sendSuccess(res, "Bulk activation completed", result);
    } catch (error: any) {
      ResponseUtil.sendError(res, error.message, error, 400);
    }
  }

  async bulkDeactivateGrades(req: Request, res: Response): Promise<void> {
    try {
      const { ids } = req.body;
      if (!Array.isArray(ids)) {
        ResponseUtil.sendError(res, "IDs must be an array", null, 400);
        return;
      }

      const result = await this.bulkGradeOperationsUseCase.bulkDeactivate(ids);
      ResponseUtil.sendSuccess(res, "Bulk deactivation completed", result);
    } catch (error: any) {
      ResponseUtil.sendError(res, error.message, error, 400);
    }
  }
}
