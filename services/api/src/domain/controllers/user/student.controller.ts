import { NextFunction } from "express-serve-static-core";
import { IStudent } from "../../models";
import { Request, Response } from "express";
import chalk from "chalk";

import { StudentService } from "../../services";
import {
  sendUnauthorized,
  sendSuccess,
  sendNotFound,
  sendEmpty,
} from "../../../common/utils/ResponseHelper";
import { buildQueryOptions } from "../../../common/utils/buildQueryOptions";
class StudentController {
  private readonly studentService: StudentService;

  constructor(studentService: StudentService) {
    this.studentService = studentService;
  }

  async getAllStudents(
    req: Request,
    res: Response,
    next: NextFunction
  ): Promise<void> {
    const actorId = req.user?.id;
    const userRole = req.role;
    if (!userRole || !actorId) {
      sendUnauthorized(res);
      return;
    }

    const schoolId = req.user?.schoolId;

    const options = buildQueryOptions(req.query as any);

    try {
      const students = await this.studentService.getAllStudents(
        actorId,
        userRole,
        schoolId,
        options
      );
      if (!students || students.length === 0) {
        sendEmpty(res);
        return;
      }

      sendSuccess(res, students, "Lấy danh sách học sinh thành công");
      return;
    } catch (error) {
      console.error(chalk.red("[STUDENTS] Error getting all students:", error));
      return next(error);
    }
  }
  async getStudentById(
    req: Request,
    res: Response,
    next: NextFunction
  ): Promise<void> {
    const actorId = req.user?.id;
    const userRole = req.role;

    if (!userRole || !actorId) {
      sendUnauthorized(res);
      return;
    }
    const studentId = req.params.id;

    try {
      const student = await this.studentService.getStudentById(
        studentId,
        actorId,
        userRole
      );
      if (!student) {
        sendNotFound(res);
        return;
      }

      sendSuccess(res, student, "Lấy thông tin học sinh từ ID thành công");
      return;
    } catch (error) {
      console.error(chalk.red("[STUDENTS] Error getting student by ID", error));
      return next(error);
    }
  }
  async createStudent(
    req: Request,
    res: Response,
    next: NextFunction
  ): Promise<void> {
    const actorId = req.user?.id;
    const userRole = req.role;
    if (!userRole || !actorId) {
      sendUnauthorized(res);
      return;
    }
    const studentData = req.body;

    try {
      const newStudent = await this.studentService.createStudent(
        studentData,
        actorId,
        userRole
      );

      sendSuccess(res, newStudent, "Tạo mới học sinh mới thành công");
      return;
    } catch (error) {
      console.log(chalk.red("[STUDENTS] Error creatting new student:", error));
      return next(error);
    }
  }

  async updateStudent(
    req: Request,
    res: Response,
    next: NextFunction
  ): Promise<void> {
    try {
      const actorId = req.user?.id;
      const userRole = req.role;
      if (!userRole || !actorId) {
        sendUnauthorized(res);
        return;
      }
      const studentId = req.params.id;
      if (!studentId) {
        sendNotFound(res);
        return;
      }
      const studentData: Partial<IStudent> = req.body;
      const updatedStudent = await this.studentService.updateStudent(
        studentId,
        studentData,
        actorId,
        userRole
      );

      sendSuccess(
        res,
        updatedStudent,
        "Cập nhật thông tin học sinh thành công"
      );
      return;
    } catch (error) {
      console.log(chalk.red("[STUDENTS] Error updating student:", error));
      return next(error);
    }
  }

  async deleteStudent(
    req: Request,
    res: Response,
    next: NextFunction
  ): Promise<void> {
    const actorId = req.user?.id;
    const userRole = req.role;
    if (!userRole || !actorId) {
      sendUnauthorized(res);
      return;
    }

    const studentId = req.params.id;
    if (!studentId) {
      sendNotFound(res);
      return;
    }

    try {
      const deletedStudent = await this.studentService.deleteStudent(
        studentId,
        actorId,
        userRole
      );

      sendSuccess(res, deletedStudent, "Xóa thông tin học sinh thành công");
      return;
    } catch (error) {
      console.log(chalk.red("[STUDENTS] Error delete student:", error));
      return next(error);
    }
  }
}

export default StudentController;
