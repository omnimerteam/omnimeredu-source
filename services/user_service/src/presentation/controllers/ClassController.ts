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
      res.status(201).json(classEntity);
    } catch (error: any) {
      res.status(400).json({ error: error.message });
    }
  }

  async getClassById(req: Request, res: Response): Promise<void> {
    try {
      const { id } = req.params;
      const classEntity = await this.getClassByIdUseCase.execute(id);
      if (!classEntity) {
        res.status(404).json({ error: "Class not found" });
        return;
      }
      res.status(200).json(classEntity);
    } catch (error: any) {
      res.status(400).json({ error: error.message });
    }
  }

  async getClassesBySchoolId(req: Request, res: Response): Promise<void> {
    try {
      const { schoolId } = req.params;
      const classes = await this.getClassesBySchoolIdUseCase.execute(schoolId);
      res.status(200).json(classes);
    } catch (error: any) {
      res.status(400).json({ error: error.message });
    }
  }

  async updateClass(req: Request, res: Response): Promise<void> {
    try {
      const { id } = req.params;
      const dto: UpdateClassDto = req.body;
      const classEntity = await this.updateClassUseCase.execute(id, dto);
      res.status(200).json(classEntity);
    } catch (error: any) {
      const statusCode = error.message === "Class not found" ? 404 : 400;
      res.status(statusCode).json({ error: error.message });
    }
  }

  async deleteClass(req: Request, res: Response): Promise<void> {
    try {
      const { id } = req.params;
      const success = await this.deleteClassUseCase.execute(id);
      res.status(200).json({ success, message: "Class deleted successfully" });
    } catch (error: any) {
      const statusCode = error.message === "Class not found" ? 404 : 400;
      res.status(statusCode).json({ error: error.message });
    }
  }

  async getStudentsByClassId(req: Request, res: Response): Promise<void> {
    try {
      const { id } = req.params;
      const students = await this.getStudentsByClassIdUseCase.execute(id);
      res.status(200).json(students);
    } catch (error: any) {
      res.status(400).json({ error: error.message });
    }
  }
}
