import { Request, Response } from "express";
import { RegisterSchoolUseCase } from "../../domain/usecases/school/RegisterSchoolUseCase";
import { GetSchoolByIdUseCase } from "../../domain/usecases/school/GetSchoolByIdUseCase";
import { UpdateSchoolUseCase } from "../../domain/usecases/school/UpdateSchoolUseCase";
import { DeleteSchoolUseCase } from "../../domain/usecases/school/DeleteSchoolUseCase";
import { SchoolRepositoryImpl } from "../../data/repositories/SchoolRepositoryImpl";
import { ClassRepositoryImpl } from "../../data/repositories/ClassRepositoryImpl";
import { CreateSchoolDto } from "../dtos/CreateSchoolDto";
import { UpdateSchoolDto } from "../dtos/UpdateSchoolDto";

export class SchoolController {
  private registerSchoolUseCase: RegisterSchoolUseCase;
  private getSchoolByIdUseCase: GetSchoolByIdUseCase;
  private updateSchoolUseCase: UpdateSchoolUseCase;
  private deleteSchoolUseCase: DeleteSchoolUseCase;
  private schoolRepository: SchoolRepositoryImpl;
  private classRepository: ClassRepositoryImpl;

  constructor() {
    this.schoolRepository = new SchoolRepositoryImpl();
    this.classRepository = new ClassRepositoryImpl();
    this.registerSchoolUseCase = new RegisterSchoolUseCase(this.schoolRepository);
    this.getSchoolByIdUseCase = new GetSchoolByIdUseCase(this.schoolRepository);
    this.updateSchoolUseCase = new UpdateSchoolUseCase(this.schoolRepository);
    this.deleteSchoolUseCase = new DeleteSchoolUseCase(this.schoolRepository);
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

  /**
   * Get schools by education level
   * GET /api/schools?educationLevel=<level>&search=<query>
   */
  async getSchools(req: Request, res: Response): Promise<void> {
    try {
      const { educationLevel, search } = req.query;

      if (!educationLevel) {
        res.status(400).json({
          success: false,
          message: "Education level is required"
        });
        return;
      }

      const schools = await this.schoolRepository.getSchoolsByLevel({
        educationLevel: educationLevel as string,
        search: search as string,
      });

      res.status(200).json({
        success: true,
        message: "Schools retrieved successfully",
        schools: schools.map(school => ({
          id: school.id,
          name: school.name,
          code: school.code,
          address: school.address,
          level: school.level,
          logoUrl: school.logoUrl,
          phone: school.phone,
          description: school.description,
        })),
      });
    } catch (error: any) {
      res.status(500).json({
        success: false,
        message: error.message || "Failed to get schools"
      });
    }
  }

  /**
   * Get classes by school ID
   * GET /api/schools/:schoolId/classes?grade=<grade>
   */
  async getClassesBySchool(req: Request, res: Response): Promise<void> {
    try {
      const { schoolId } = req.params;
      const { grade } = req.query;

      const classes = await this.classRepository.getClassesBySchool({
        schoolId,
        grade: grade as string,
      });

      res.status(200).json({
        success: true,
        message: "Classes retrieved successfully",
        classes: classes.map(cls => ({
          id: cls.id,
          name: cls.name,
          code: cls.code,
          grade: cls.grade,
          level: cls.level,
          maxStudents: cls.maxStudents,
          currentStudents: cls.currentStudents,
        })),
      });
    } catch (error: any) {
      res.status(500).json({
        success: false,
        message: error.message || "Failed to get classes"
      });
    }
  }
}
