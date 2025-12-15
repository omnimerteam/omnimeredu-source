import { Request, Response } from "express";
import { CreateClassUseCase } from "../../domain/usecases/class/CreateClassUseCase";
import { GetClassByIdUseCase } from "../../domain/usecases/class/GetClassByIdUseCase";
import { GetClassesBySchoolIdUseCase } from "../../domain/usecases/class/GetClassesBySchoolIdUseCase";
import { UpdateClassUseCase } from "../../domain/usecases/class/UpdateClassUseCase";
import { DeleteClassUseCase } from "../../domain/usecases/class/DeleteClassUseCase";
import { GetStudentsByClassIdUseCase } from "../../domain/usecases/class/GetStudentsByClassIdUseCase";
import { ClassRepositoryImpl } from "../../data/repositories/ClassRepositoryImpl";
import { ClassReadRepositoryImpl } from "../../data/repositories/ClassReadRepositoryImpl";
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

  constructor() {
    const classRepository = new ClassRepositoryImpl();
    const classReadRepository = new ClassReadRepositoryImpl();
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
}
