import { Request, Response, NextFunction } from "express";
import chalk from "chalk";
import ClassService from "../services/class.service";
import { sendSuccess, sendCreated } from "../utils/ResponseHelper";
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
      const result = await this.classService.getAllClasses(userId);
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
  async getByIdClass(
    req: Request,
    res: Response,
    next: NextFunction
  ): Promise<void> {
    try {
      const userId = req.user?.id;
      const { id } = req.params;

      const result = await this.classService.getClassById(userId, id);
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
      const body = req.body;

      const result = await this.classService.createClass(userId, body);
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
      const { id } = req.params;
      const body = req.body;

      const result = await this.classService.updateClass(userId, id, body);
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
  async removeClass(
    req: Request,
    res: Response,
    next: NextFunction
  ): Promise<void> {
    try {
      const userId = req.user?.id;
      const { id } = req.params;

      const result = await this.classService.deleteClass(userId, id);
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
}

export default ClassController;
