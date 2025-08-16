import { Request, Response, NextFunction } from "express";
import chalk from "chalk";
import ClassService from "../services/class.services";
import {
  sendSuccess,
  sendCreated,
  sendUnauthorized,
  sendForbidden,
  sendEmpty,
} from "../utils/ResponseHelper";
import { CustomError } from "../middlewares/errorHandler.middleware";

class ClassController {
  private classService: ClassService;

  constructor(classService: ClassService) {
    this.classService = classService;
  }

  /**
   * Lấy tất cả lớp học mà người dùng có quyền xem
   */
  async getAllClasses(
    req: Request,
    res: Response,
    next: NextFunction
  ): Promise<void> {
    try {
      const userId = req.user?.id;
      const userRole = req.role;
      if (!userRole || !userId) {
        sendUnauthorized(res);
        return;
      }

      const schoolId = req.user?.schoolId;

      const options = {
        page: parseInt(req.query.page as string) || 1,
        limit: parseInt(req.query.limit as string) || 10,
        sort: req.query.sortBy
          ? { [req.query.sortBy as string]: req.query.order === "asc" ? 1 : -1 }
          : undefined,
      };

      const result = await this.classService.getAllClasses(
        userId,
        userRole,
        schoolId,
        options
      );

      if (!result || result.length === 0) {
        console.log(chalk.yellow("[CLASS] No classes found for user"));
        sendEmpty(res, "Không có lớp học phù hợp");
        return;
      }

      console.log(chalk.green("[CLASS] ✅ Get all classes"));
      sendSuccess(res, result, "Lấy danh sách lớp thành công");
      return;
    } catch (error) {
      console.log(chalk.red("[CLASS] ❌ Get all classes failed"), error);
      return next(error);
    }
  }

  /**
   * Lấy lớp học theo ID
   */
  async getClassById(
    req: Request,
    res: Response,
    next: NextFunction
  ): Promise<void> {
    try {
      const userId = req.user?.id;
      const userRole = req.role;
      if (!userRole || !userId) {
        sendUnauthorized(res);
        return;
      }

      const { id } = req.params;

      const result = await this.classService.getClassById(userId, userRole, id);
      if (!result) {
        const error: CustomError = new Error("Không tìm thấy lớp");
        error.status = 404;
        return next(error);
      }

      console.log(chalk.green("[CLASS] ✅ Get class by ID"), id);
      sendSuccess(res, result, "Lấy thông tin lớp thành công");
      return;
    } catch (error) {
      console.log(chalk.red("[CLASS] ❌ Get class by ID failed"), error);
      return next(error);
    }
  }

  /**
   * Tạo một lớp học mới
   */
  async createClass(
    req: Request,
    res: Response,
    next: NextFunction
  ): Promise<void> {
    try {
      const userId = req.user?.id;
      const userRole = req.role;
      if (!userRole || !userId) {
        sendUnauthorized(res);
        return;
      }

      const body = req.body;

      const result = await this.classService.createClass(
        userId,
        userRole,
        body
      );
      console.log(
        chalk.green("[CLASS] ✅ Create class"),
        result._id.toString()
      );
      sendCreated(res, result, "Tạo lớp thành công");
      return;
    } catch (error) {
      console.log(chalk.red("[CLASS] ❌ Create class failed"), error);
      return next(error);
    }
  }

  /**
   * Cập nhật thông tin lớp học
   */
  async updateClass(
    req: Request,
    res: Response,
    next: NextFunction
  ): Promise<void> {
    try {
      const userId = req.user?.id;
      const userRole = req.role;
      if (!userRole || !userId) {
        sendUnauthorized(res);
        return;
      }

      const { id } = req.params;
      const body = req.body;

      const result = await this.classService.updateClass(
        userId,
        userRole,
        id,
        body
      );

      if (!result) {
        const error: CustomError = new Error("Không tìm thấy lớp để cập nhật");
        error.status = 404;
        return next(error);
      }

      console.log(chalk.green("[CLASS] ✅ Update class"), id);
      sendSuccess(res, result, "Cập nhật lớp thành công");
      return;
    } catch (error) {
      console.log(chalk.red("[CLASS] ❌ Update class failed"), error);
      return next(error);
    }
  }

  /**
   * Xóa lớp học
   */
  async deleteClass(
    req: Request,
    res: Response,
    next: NextFunction
  ): Promise<void> {
    try {
      const userId = req.user?.id;
      const userRole = req.role;
      if (!userRole || !userId) {
        sendUnauthorized(res);
        return;
      }

      const { id } = req.params;

      const result = await this.classService.deleteClass(userId, userRole, id);
      if (!result) {
        const error: CustomError = new Error("Không tìm thấy lớp để xóa");
        error.status = 404;
        return next(error);
      }

      console.log(chalk.green("[CLASS] ✅ Delete class"), id);
      sendSuccess(res, null, "Đã xóa lớp thành công");
      return;
    } catch (error) {
      console.log(chalk.red("[CLASS] ❌ Delete class failed"), error);
      return next(error);
    }
  }

  async addStudentToClass(
    req: Request,
    res: Response,
    next: NextFunction
  ): Promise<void> {
    try {
      const userId = req.user?.id;
      const userRole = req.role;
      if (!userId || !userRole) {
        console.log(
          chalk.yellow("[CLASS] ❌ Transfer class - Unauthorized access")
        );
        sendUnauthorized(res);
        return;
      }

      const classId = req.params.id;
      const { studentIds } = req.body;

      const result = await this.classService.addStudentToClass(
        userId,
        userRole,
        classId,
        studentIds
      );

      console.log(chalk.green("[CLASS] ✅ Add students to class"), result);
      sendSuccess(res, result, "Thêm học sinh vào lớp thành công");
    } catch (error) {
      console.log(chalk.red("[CLASS] ❌ Add students to class failed"), error);
      next(error);
    }
  }

  async removeStudentFromClass(
    req: Request,
    res: Response,
    next: NextFunction
  ): Promise<void> {
    try {
      const userId = req.user?.id;
      const userRole = req.role;
      if (!userId || !userRole) {
        console.log(
          chalk.yellow("[CLASS] ❌ Transfer class - Unauthorized access")
        );
        sendUnauthorized(res);
        return;
      }

      const classId = req.params.id;
      const { studentIds } = req.body;

      const result = await this.classService.removeStudentFromClass(
        userId,
        userRole,
        classId,
        studentIds
      );

      console.log(chalk.green("[CLASS] ✅ Remove students from class"), result);
      sendSuccess(res, result, "Xóa học sinh khỏi lớp thành công");
    } catch (error) {
      console.log(
        chalk.red("[CLASS] ❌ Remove students from class failed"),
        error
      );
      next(error);
    }
  }

  async transferClass(
    req: Request,
    res: Response,
    next: NextFunction
  ): Promise<void> {
    try {
      const userId = req.user?._id;
      const userRole = req.role;
      if (!userId || !userRole) {
        console.log(
          chalk.yellow("[CLASS] ❌ Transfer class - Unauthorized access")
        );
        sendUnauthorized(res);
        return;
      }

      const { toClassId, studentIds } = req.body;

      const result = await this.classService.transferClass(
        userId,
        userRole,
        toClassId,
        studentIds
      );

      console.log(
        chalk.green("[CLASS] ✅ Transfer students to new class"),
        result
      );
      sendSuccess(res, result, "Chuyển lớp cho học sinh thành công");
    } catch (error) {
      console.log(chalk.red("[CLASS] ❌ Transfer class failed"), error);
      next(error);
    }
  }
}

export default ClassController;
