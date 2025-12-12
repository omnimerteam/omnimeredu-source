import { Request, Response } from "express";
import { RegisterSchoolUseCase } from "../../domain/usecases/school/RegisterSchoolUseCase";
import { GetSchoolByIdUseCase } from "../../domain/usecases/school/GetSchoolByIdUseCase";
import { UpdateSchoolUseCase } from "../../domain/usecases/school/UpdateSchoolUseCase";
import { DeleteSchoolUseCase } from "../../domain/usecases/school/DeleteSchoolUseCase";
import { SchoolRepositoryImpl } from "../../data/repositories/SchoolRepositoryImpl";
import { CreateSchoolDto } from "../dtos/CreateSchoolDto";
import { UpdateSchoolDto } from "../dtos/UpdateSchoolDto";

export class SchoolController {
  private registerSchoolUseCase: RegisterSchoolUseCase;
  private getSchoolByIdUseCase: GetSchoolByIdUseCase;
  private updateSchoolUseCase: UpdateSchoolUseCase;
  private deleteSchoolUseCase: DeleteSchoolUseCase;

  constructor() {
    const schoolRepository = new SchoolRepositoryImpl();
    this.registerSchoolUseCase = new RegisterSchoolUseCase(schoolRepository);
    this.getSchoolByIdUseCase = new GetSchoolByIdUseCase(schoolRepository);
    this.updateSchoolUseCase = new UpdateSchoolUseCase(schoolRepository);
    this.deleteSchoolUseCase = new DeleteSchoolUseCase(schoolRepository);
  }

  async registerSchool(req: Request, res: Response): Promise<void> {
    try {
      const dto: CreateSchoolDto = req.body;
      const school = await this.registerSchoolUseCase.execute(dto);
      res.status(201).json(school);
    } catch (error: any) {
      res.status(400).json({ error: error.message });
    }
  }

  async getSchoolById(req: Request, res: Response): Promise<void> {
    try {
      const { id } = req.params;
      const school = await this.getSchoolByIdUseCase.execute(id);
      if (!school) {
        res.status(404).json({ error: "School not found" });
        return;
      }
      res.status(200).json(school);
    } catch (error: any) {
      res.status(400).json({ error: error.message });
    }
  }

  async updateSchool(req: Request, res: Response): Promise<void> {
    try {
      const { id } = req.params;
      const dto: UpdateSchoolDto = req.body;
      const school = await this.updateSchoolUseCase.execute(id, dto);
      res.status(200).json(school);
    } catch (error: any) {
      const statusCode = error.message === "School not found" ? 404 : 400;
      res.status(statusCode).json({ error: error.message });
    }
  }

  async deleteSchool(req: Request, res: Response): Promise<void> {
    try {
      const { id } = req.params;
      const success = await this.deleteSchoolUseCase.execute(id);
      res.status(200).json({ success, message: "School deleted successfully" });
    } catch (error: any) {
      const statusCode = error.message === "School not found" ? 404 : 400;
      res.status(statusCode).json({ error: error.message });
    }
  }
}
