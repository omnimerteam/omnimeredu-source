import { Request, Response } from "express";
import { CreateGradeUseCase } from "../../domain/usecases/grade/CreateGradeUseCase";
import { GetGradeByIdUseCase } from "../../domain/usecases/grade/GetGradeByIdUseCase";
import { GetGradesBySchoolIdUseCase } from "../../domain/usecases/grade/GetGradesBySchoolIdUseCase";
import { UpdateGradeUseCase } from "../../domain/usecases/grade/UpdateGradeUseCase";
import { DeleteGradeUseCase } from "../../domain/usecases/grade/DeleteGradeUseCase";
import { GradeRepositoryImpl } from "../../data/repositories/GradeRepositoryImpl";
import { CreateGradeDto } from "../dtos/CreateGradeDto";
import { UpdateGradeDto } from "../dtos/UpdateGradeDto";

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
      res.status(201).json(grade);
    } catch (error: any) {
      res.status(400).json({ error: error.message });
    }
  }

  async getGradeById(req: Request, res: Response): Promise<void> {
    try {
      const { id } = req.params;
      const grade = await this.getGradeByIdUseCase.execute(id);
      if (!grade) {
        res.status(404).json({ error: "Grade not found" });
        return;
      }
      res.status(200).json(grade);
    } catch (error: any) {
      res.status(400).json({ error: error.message });
    }
  }

  async getGradesBySchoolId(req: Request, res: Response): Promise<void> {
    try {
      const { schoolId } = req.params;
      const grades = await this.getGradesBySchoolIdUseCase.execute(schoolId);
      res.status(200).json(grades);
    } catch (error: any) {
      res.status(400).json({ error: error.message });
    }
  }

  async updateGrade(req: Request, res: Response): Promise<void> {
    try {
      const { id } = req.params;
      const dto: UpdateGradeDto = req.body;
      const grade = await this.updateGradeUseCase.execute(id, dto);
      res.status(200).json(grade);
    } catch (error: any) {
      const statusCode = error.message === "Grade not found" ? 404 : 400;
      res.status(statusCode).json({ error: error.message });
    }
  }

  async deleteGrade(req: Request, res: Response): Promise<void> {
    try {
      const { id } = req.params;
      const success = await this.deleteGradeUseCase.execute(id);
      res.status(200).json({ success, message: "Grade deleted successfully" });
    } catch (error: any) {
      const statusCode = error.message === "Grade not found" ? 404 : 400;
      res.status(statusCode).json({ error: error.message });
    }
  }
}
