import { Request, Response } from "express";
import { RegisterSchoolUseCase } from "../../domain/usecases/school/RegisterSchoolUseCase";
import { SchoolRepositoryImpl } from "../../data/repositories/SchoolRepositoryImpl";
import { CreateSchoolDto } from "../dtos/CreateSchoolDto";

export class SchoolController {
  private registerSchoolUseCase: RegisterSchoolUseCase;

  constructor() {
    const schoolRepository = new SchoolRepositoryImpl();
    this.registerSchoolUseCase = new RegisterSchoolUseCase(schoolRepository);
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
}
