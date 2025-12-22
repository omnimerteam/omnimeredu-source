import { Request, Response } from "express";
import { RegisterSchoolUseCase } from "../../domain/usecases/school/RegisterSchoolUseCase";
import { GetSchoolByIdUseCase } from "../../domain/usecases/school/GetSchoolByIdUseCase";
import { UpdateSchoolUseCase } from "../../domain/usecases/school/UpdateSchoolUseCase";
import { DeleteSchoolUseCase } from "../../domain/usecases/school/DeleteSchoolUseCase";
import { GetSchoolsByLevelUseCase } from "../../domain/usecases/school/GetSchoolsByLevelUseCase";
import { GetClassesBySchoolUseCase } from "../../domain/usecases/class/GetClassesBySchoolUseCase";
import { SearchSchoolsUseCase } from "../../domain/usecases/school/SearchSchoolsUseCase";
import { GetSchoolDetailsForAdminUseCase } from "../../domain/usecases/school/GetSchoolDetailsForAdminUseCase";
import { SchoolRepositoryImpl } from "../../data/repositories/SchoolRepositoryImpl";
import { ClassRepositoryImpl } from "../../data/repositories/ClassRepositoryImpl";
import { CreateSchoolDto } from "../dtos/CreateSchoolDto";
import { UpdateSchoolDto } from "../dtos/UpdateSchoolDto";
import { ResponseUtil } from "../../infrastructure/utils/ResponseUtil";
import { EducationSystemLevelsEnum } from "shared-lib";

export class SchoolController {
  private registerSchoolUseCase: RegisterSchoolUseCase;
  private getSchoolByIdUseCase: GetSchoolByIdUseCase;
  private updateSchoolUseCase: UpdateSchoolUseCase;
  private deleteSchoolUseCase: DeleteSchoolUseCase;
  private getSchoolsByLevelUseCase: GetSchoolsByLevelUseCase;
  private getClassesBySchoolUseCase: GetClassesBySchoolUseCase;
  private searchSchoolsUseCase: SearchSchoolsUseCase;
  private getSchoolDetailsForAdminUseCase: GetSchoolDetailsForAdminUseCase;
  private schoolRepository: SchoolRepositoryImpl;
  private classRepository: ClassRepositoryImpl;

  constructor() {
    this.schoolRepository = new SchoolRepositoryImpl();
    this.classRepository = new ClassRepositoryImpl();
    this.registerSchoolUseCase = new RegisterSchoolUseCase(
      this.schoolRepository
    );
    this.getSchoolByIdUseCase = new GetSchoolByIdUseCase(this.schoolRepository);
    this.updateSchoolUseCase = new UpdateSchoolUseCase(this.schoolRepository);
    this.deleteSchoolUseCase = new DeleteSchoolUseCase(this.schoolRepository);
    this.getSchoolsByLevelUseCase = new GetSchoolsByLevelUseCase(
      this.schoolRepository
    );
    this.getClassesBySchoolUseCase = new GetClassesBySchoolUseCase(
      this.classRepository
    );
    this.searchSchoolsUseCase = new SearchSchoolsUseCase(this.schoolRepository);
    this.getSchoolDetailsForAdminUseCase = new GetSchoolDetailsForAdminUseCase(
      this.schoolRepository
    );
  }

  async registerSchool(req: Request, res: Response): Promise<void> {
    try {
      const dto: CreateSchoolDto = req.body;
      const school = await this.registerSchoolUseCase.execute(dto);
      ResponseUtil.sendSuccess(
        res,
        "School registered successfully",
        school,
        201
      );
    } catch (error: any) {
      ResponseUtil.sendError(res, error.message, error, 400);
    }
  }

  async getSchoolById(req: Request, res: Response): Promise<void> {
    try {
      // Support both :id (old route) and :schoolId (internal route)
      const id = req.params.id || req.params.schoolId;
      const school = await this.getSchoolByIdUseCase.execute(id);
      if (!school) {
        ResponseUtil.sendError(res, "School not found", null, 404);
        return;
      }
      ResponseUtil.sendSuccess(res, "School retrieved successfully", school);
    } catch (error: any) {
      ResponseUtil.sendError(res, error.message, error, 400);
    }
  }

  async updateSchool(req: Request, res: Response): Promise<void> {
    try {
      const { id } = req.params;
      const dto: UpdateSchoolDto = req.body;
      const school = await this.updateSchoolUseCase.execute(id, dto);
      ResponseUtil.sendSuccess(res, "School updated successfully", school);
    } catch (error: any) {
      const statusCode = error.message === "School not found" ? 404 : 400;
      ResponseUtil.sendError(res, error.message, error, statusCode);
    }
  }

  async deleteSchool(req: Request, res: Response): Promise<void> {
    try {
      const { id } = req.params;
      const success = await this.deleteSchoolUseCase.execute(id);
      ResponseUtil.sendSuccess(res, "School deleted successfully", { success });
    } catch (error: any) {
      const statusCode = error.message === "School not found" ? 404 : 400;
      ResponseUtil.sendError(res, error.message, error, statusCode);
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
        ResponseUtil.sendError(res, "Education level is required", null, 400);
        return;
      }

      const schools = await this.getSchoolsByLevelUseCase.execute({
        educationLevel: educationLevel as unknown as EducationSystemLevelsEnum,
        search: search as string,
      });

      const schoolsData = schools.map((school) => ({
        id: school.id,
        name: school.name,
        code: school.code,
        address: school.address,
        level: school.level,
        logoUrl: school.logoUrl,
        phone: school.phone,
        description: school.description,
      }));

      ResponseUtil.sendSuccess(
        res,
        "Schools retrieved successfully",
        schoolsData
      );
    } catch (error: any) {
      ResponseUtil.sendError(
        res,
        error.message || "Failed to get schools",
        error,
        500
      );
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

      const classes = await this.getClassesBySchoolUseCase.execute({
        schoolId,
        grade: grade as string,
      });

      const classesData = classes.map((cls) => ({
        id: cls.id,
        name: cls.name,
        code: cls.code,
        schoolId: cls.schoolId,
        gradeId: cls.grade, // Map 'grade' from repo (which is gradeId) to 'gradeId' for JSON
        grade: cls.grade, // Map 'grade' from repo to 'grade' for JSON (for enum parsing)
        level: cls.level,
        maxStudents: cls.maxStudents,
        currentStudents: cls.currentStudents,
      }));

      ResponseUtil.sendSuccess(
        res,
        "Classes retrieved successfully",
        classesData
      );
    } catch (error: any) {
      ResponseUtil.sendError(
        res,
        error.message || "Failed to get classes",
        error,
        500
      );
    }
  }

  async searchSchoolByEducationLevel(
    req: Request,
    res: Response
  ): Promise<void> {
    try {
      const { educationLevel, search, limit, offset } = req.query;

      const schools = await this.searchSchoolsUseCase.execute({
        educationLevel: educationLevel as unknown as EducationSystemLevelsEnum,
        search: search as string,
        limit: limit ? parseInt(limit as string) : undefined,
        offset: offset ? parseInt(offset as string) : undefined,
      });

      const schoolsData = schools.map((school) => ({
        id: school.id,
        name: school.name,
        code: school.code,
        address: school.address,
        level: school.level,
        logoUrl: school.logoUrl,
        phone: school.phone,
        description: school.description,
        studentCount: school.studentCount,
      }));

      ResponseUtil.sendSuccess(
        res,
        "Schools searched successfully",
        schoolsData
      );
    } catch (error: any) {
      ResponseUtil.sendError(
        res,
        error.message || "Failed to search schools",
        error,
        500
      );
    }
  }

  async getSchoolDetailForSchoolAdmin(
    req: Request,
    res: Response
  ): Promise<void> {
    try {
      // Assuming userId is attached to the request from authentication middleware
      const userId = (req as any).user?.id || (req as any).user?.userId;

      if (!userId) {
        ResponseUtil.sendError(res, "User ID not found in request", null, 401);
        return;
      }

      const school = await this.getSchoolDetailsForAdminUseCase.execute(userId);

      if (!school) {
        ResponseUtil.sendError(
          res,
          "School not found for this admin",
          null,
          404
        );
        return;
      }

      const schoolData = {
        id: school.id,
        name: school.name,
        code: school.code,
        address: school.address,
        level: school.level,
        logoUrl: school.logoUrl,
        phone: school.phone,
        description: school.description,
        studentCount: school.studentCount,
        customTheme: school.customTheme,
        createdAt: school.createdAt,
        updatedAt: school.updatedAt,
      };

      ResponseUtil.sendSuccess(
        res,
        "School details retrieved successfully",
        schoolData
      );
    } catch (error: any) {
      ResponseUtil.sendError(
        res,
        error.message || "Failed to get school details",
        error,
        500
      );
    }
  }
}
