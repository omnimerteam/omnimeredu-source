import { Request, Response } from "express";
import { CreateClassUseCase } from "../../domain/usecases/class/CreateClassUseCase";
import { GetClassByIdUseCase } from "../../domain/usecases/class/GetClassByIdUseCase";
import { GetClassesBySchoolIdUseCase } from "../../domain/usecases/class/GetClassesBySchoolIdUseCase";
import { UpdateClassUseCase } from "../../domain/usecases/class/UpdateClassUseCase";
import { DeleteClassUseCase } from "../../domain/usecases/class/DeleteClassUseCase";
import { GetStudentsByClassIdUseCase } from "../../domain/usecases/class/GetStudentsByClassIdUseCase";
import { GetAllClassesUseCase, PaginationOptions, ClassFilterOptions } from "../../domain/usecases/class/GetAllClassesUseCase";
import { SearchClassesUseCase } from "../../domain/usecases/class/SearchClassesUseCase";
import { ManageStudentsUseCase, StudentOperationRequest, TransferStudentsRequest } from "../../domain/usecases/class/ManageStudentsUseCase";
import { ClassRepositoryImpl } from "../../data/repositories/ClassRepositoryImpl";
import { ClassReadRepositoryImpl } from "../../data/repositories/ClassReadRepositoryImpl";
import { StudentRepositoryImpl } from "../../data/repositories/StudentRepositoryImpl";
import { CreateClassDto } from "../dtos/CreateClassDto";
import { UpdateClassDto } from "../dtos/UpdateClassDto";
import { ResponseUtil } from "../../infrastructure/utils/ResponseUtil";

export class ClassController {
  private createClassUseCase: CreateClassUseCase;
  private getClassByIdUseCase: GetClassByIdUseCase;
  private getClassesBySchoolIdUseCase: GetClassesBySchoolIdUseCase;
  private updateClassUseCase: UpdateClassUseCase;
  private deleteClassUseCase: DeleteClassUseCase;
  private getStudentsByClassIdUseCase: GetStudentsByClassIdUseCase;
  private getAllClassesUseCase: GetAllClassesUseCase;
  private searchClassesUseCase: SearchClassesUseCase;
  private manageStudentsUseCase: ManageStudentsUseCase;

  constructor() {
    const classRepository = new ClassRepositoryImpl();
    const classReadRepository = new ClassReadRepositoryImpl();
    const studentRepository = new StudentRepositoryImpl();

    this.createClassUseCase = new CreateClassUseCase(classRepository);
    this.getClassByIdUseCase = new GetClassByIdUseCase(classRepository);
    this.getClassesBySchoolIdUseCase = new GetClassesBySchoolIdUseCase(
      classRepository
    );
    this.updateClassUseCase = new UpdateClassUseCase(classRepository);
    this.deleteClassUseCase = new DeleteClassUseCase(classRepository);
    this.getStudentsByClassIdUseCase = new GetStudentsByClassIdUseCase(
      classReadRepository
    );
    this.getAllClassesUseCase = new GetAllClassesUseCase(classRepository);
    this.searchClassesUseCase = new SearchClassesUseCase(classRepository);
    this.manageStudentsUseCase = new ManageStudentsUseCase(classRepository, studentRepository);
  }

  async createClass(req: Request, res: Response): Promise<void> {
    try {
      const dto: CreateClassDto = req.body;
      const classEntity = await this.createClassUseCase.execute(dto);
      ResponseUtil.sendSuccess(
        res,
        "Class created successfully",
        classEntity,
        201
      );
    } catch (error: any) {
      ResponseUtil.sendError(res, error.message, error, 400);
    }
  }

  async getClassById(req: Request, res: Response): Promise<void> {
    try {
      const { id } = req.params;
      const classEntity = await this.getClassByIdUseCase.execute(id);
      if (!classEntity) {
        ResponseUtil.sendError(res, "Class not found", null, 404);
        return;
      }
      ResponseUtil.sendSuccess(
        res,
        "Class retrieved successfully",
        classEntity
      );
    } catch (error: any) {
      ResponseUtil.sendError(res, error.message, error, 400);
    }
  }

  async getClassesBySchoolId(req: Request, res: Response): Promise<void> {
    try {
      const { schoolId } = req.params;
      const classes = await this.getClassesBySchoolIdUseCase.execute(schoolId);
      ResponseUtil.sendSuccess(res, "Classes retrieved successfully", classes);
    } catch (error: any) {
      ResponseUtil.sendError(res, error.message, error, 400);
    }
  }

  async updateClass(req: Request, res: Response): Promise<void> {
    try {
      const { id } = req.params;
      const dto: UpdateClassDto = req.body;
      const classEntity = await this.updateClassUseCase.execute(id, dto);
      ResponseUtil.sendSuccess(res, "Class updated successfully", classEntity);
    } catch (error: any) {
      const statusCode = error.message === "Class not found" ? 404 : 400;
      ResponseUtil.sendError(res, error.message, error, statusCode);
    }
  }

  async deleteClass(req: Request, res: Response): Promise<void> {
    try {
      const { id } = req.params;
      const success = await this.deleteClassUseCase.execute(id);
      ResponseUtil.sendSuccess(res, "Class deleted successfully", { success });
    } catch (error: any) {
      const statusCode = error.message === "Class not found" ? 404 : 400;
      ResponseUtil.sendError(res, error.message, error, statusCode);
    }
  }

  async getStudentsByClassId(req: Request, res: Response): Promise<void> {
    try {
      const { id } = req.params;
      const students = await this.getStudentsByClassIdUseCase.execute(id);
      ResponseUtil.sendSuccess(
        res,
        "Students retrieved successfully",
        students
      );
    } catch (error: any) {
      ResponseUtil.sendError(res, error.message, error, 400);
    }
  }

  async getAllClasses(req: Request, res: Response): Promise<void> {
    try {
      const {
        page = 1,
        limit = 20,
        sortBy = 'name',
        sortOrder = 'asc',
        gradeId,
        maxStudents,
        active,
        schoolId
      } = req.query;

      const pagination: PaginationOptions = {
        page: parseInt(page as string),
        limit: parseInt(limit as string),
        sortBy: sortBy as string,
        sortOrder: sortOrder as 'asc' | 'desc'
      };

      const filters: ClassFilterOptions = {};
      if (schoolId) filters.schoolId = schoolId as string;
      if (gradeId) filters.gradeId = gradeId as string;
      if (maxStudents !== undefined) filters.maxStudents = parseInt(maxStudents as string);
      if (active !== undefined) filters.active = active === 'true';

      const result = await this.getAllClassesUseCase.execute(pagination, filters);
      ResponseUtil.sendSuccess(res, "Classes retrieved successfully", result);
    } catch (error: any) {
      ResponseUtil.sendError(res, error.message, error, 400);
    }
  }

  async searchClassesInSchool(req: Request, res: Response): Promise<void> {
    try {
      const { query, schoolId, gradeId, limit, offset } = req.query;

      const classes = await this.searchClassesUseCase.execute({
        query: query as string,
        schoolId: schoolId as string,
        gradeId: gradeId as string,
        limit: limit ? parseInt(limit as string) : undefined,
        offset: offset ? parseInt(offset as string) : undefined
      });

      ResponseUtil.sendSuccess(res, "Classes searched successfully", classes);
    } catch (error: any) {
      ResponseUtil.sendError(res, error.message, error, 400);
    }
  }

  async addStudentToClass(req: Request, res: Response): Promise<void> {
    try {
      const { id } = req.params;
      const { studentIds } = req.body;

      const request: StudentOperationRequest = {
        classId: id,
        studentIds
      };

      await this.manageStudentsUseCase.addStudentsToClass(request);
      ResponseUtil.sendSuccess(res, "Students added to class successfully", null);
    } catch (error: any) {
      ResponseUtil.sendError(res, error.message, error, 400);
    }
  }

  async removeStudentFromClass(req: Request, res: Response): Promise<void> {
    try {
      const { id } = req.params;
      const { studentIds } = req.body;

      const request: StudentOperationRequest = {
        classId: id,
        studentIds
      };

      await this.manageStudentsUseCase.removeStudentsFromClass(request);
      ResponseUtil.sendSuccess(res, "Students removed from class successfully", null);
    } catch (error: any) {
      ResponseUtil.sendError(res, error.message, error, 400);
    }
  }

  async transferClass(req: Request, res: Response): Promise<void> {
    try {
      const { id } = req.params;
      const { toClassId, studentIds } = req.body;

      const request: TransferStudentsRequest = {
        fromClassId: id,
        toClassId,
        studentIds
      };

      await this.manageStudentsUseCase.transferStudentsBetweenClasses(request);
      ResponseUtil.sendSuccess(res, "Students transferred successfully", null);
    } catch (error: any) {
      ResponseUtil.sendError(res, error.message, error, 400);
    }
  }
}
