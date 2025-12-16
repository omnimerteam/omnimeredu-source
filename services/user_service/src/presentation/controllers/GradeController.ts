import { Request, Response } from "express";
import { CreateGradeUseCase } from "../../domain/usecases/grade/CreateGradeUseCase";
import { GetGradeByIdUseCase } from "../../domain/usecases/grade/GetGradeByIdUseCase";
import { GetGradesBySchoolIdUseCase } from "../../domain/usecases/grade/GetGradesBySchoolIdUseCase";
import { UpdateGradeUseCase } from "../../domain/usecases/grade/UpdateGradeUseCase";
import { DeleteGradeUseCase } from "../../domain/usecases/grade/DeleteGradeUseCase";
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

  constructor() {
    const gradeRepository = new GradeRepositoryImpl();
    this.createGradeUseCase = new CreateGradeUseCase(gradeRepository);
    this.getGradeByIdUseCase = new GetGradeByIdUseCase(gradeRepository);
    this.getGradesBySchoolIdUseCase = new GetGradesBySchoolIdUseCase(
      gradeRepository
    );
    this.updateGradeUseCase = new UpdateGradeUseCase(gradeRepository);
    this.deleteGradeUseCase = new DeleteGradeUseCase(gradeRepository);
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
}
