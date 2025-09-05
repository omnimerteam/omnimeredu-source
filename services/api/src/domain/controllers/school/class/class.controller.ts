import { Request, Response, NextFunction } from "express";
import chalk from "chalk";
import { ClassService } from "../../../services";
import {
  sendSuccess,
  sendCreated,
  sendUnauthorized,
  sendEmpty,
  sendNotFound,
  sendBadRequest,
  sendNoContent,
} from "../../../../common/utils/ResponseHelper";
import { CustomError } from "../../../../common/api/middlewares/errorHandler.middleware";
import { buildQueryOptions } from "../../../../common/utils/buildQueryOptions";

class ClassController {
  private readonly classService: ClassService;

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
    const actorId = req.user?.id;
    const userRole = req.role;
    if (!userRole || !actorId) {
      sendUnauthorized(res);
      return;
    }

    const schoolId = req.user?.schoolId;

    const options = buildQueryOptions(req.query as any);

    try {
      const result = await this.classService.getAllClasses(
        actorId,
        userRole,
        schoolId,
        options
      );

      if (!result || result.length === 0) {
        console.log(chalk.yellow("[CLASS] No classes found for user"));
        sendEmpty(res, "Không có lớp học trong hệ thống");
        return;
      }

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
    const actorId = req.user?.id;
    const userRole = req.role;

    if (!userRole || !actorId) {
      sendUnauthorized(res);
      return;
    }

    const { id } = req.params;

    if (!id) {
      sendBadRequest(res, "Lớp học không hợp lệ");
      return;
    }

    try {
      const result = await this.classService.getClassById(
        actorId,
        userRole,
        id
      );
      if (!result) {
        sendNotFound(res, "Không tìm thấy lớp học");
        return;
      }

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
      const actorId = req.user?.id;
      const userRole = req.role;
      if (!userRole || !actorId) {
        sendUnauthorized(res);
        return;
      }

      const body = req.body;

      const result = await this.classService.createClass(
        actorId,
        userRole,
        body
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
      const actorId = req.user?.id;
      const userRole = req.role;
      if (!userRole || !actorId) {
        sendUnauthorized(res);
        return;
      }

      const { id } = req.params;
      const body = req.body;

      const result = await this.classService.updateClass(
        actorId,
        userRole,
        id,
        body
      );

      if (!result) {
        const error: CustomError = new Error("Không tìm thấy lớp để cập nhật");
        error.status = 404;
        return next(error);
      }

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
      const actorId = req.user?.id;
      const userRole = req.role;
      if (!userRole || !actorId) {
        sendUnauthorized(res);
        return;
      }

      const { id } = req.params;

      const result = await this.classService.deleteClass(actorId, userRole, id);
      if (!result) {
        const error: CustomError = new Error("Không tìm thấy lớp để xóa");
        error.status = 404;
        return next(error);
      }

      sendNoContent(res, "Đã xóa lớp thành công");
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
      const actorId = req.user?.id;
      const userRole = req.role;
      if (!actorId || !userRole) {
        console.log(
          chalk.yellow("[CLASS] ❌ Transfer class - Unauthorized access")
        );
        sendUnauthorized(res);
        return;
      }

      const classId = req.params.id;
      const { studentIds } = req.body;

      const result = await this.classService.addStudentToClass(
        actorId,
        userRole,
        classId,
        studentIds
      );

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
    const actorId = req.user?.id;
    const userRole = req.role;

    if (!actorId || !userRole) {
      console.log(
        chalk.yellow("[CLASS] ❌ Transfer class - Unauthorized access")
      );
      sendUnauthorized(res);
      return;
    }

    const classId = req.params.id;

    if (classId?.trim() === "") {
      sendBadRequest(res, "Thiếu thông tin lớp học");
      return;
    }

    const { studentIds } = req.body;

    if (!Array.isArray(studentIds) || studentIds.length === 0) {
      sendBadRequest(res, "Thiếu thông tin học sinh");
      return;
    }

    try {
      const result = await this.classService.removeStudentFromClass(
        actorId,
        userRole,
        classId,
        studentIds
      );

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
    const actorId = req.user?._id;
    const userRole = req.role;
    if (!actorId || !userRole) {
      console.log(
        chalk.yellow("[CLASS] ❌ Transfer class - Unauthorized access")
      );
      sendUnauthorized(res);
      return;
    }

    const { toClassId, studentIds } = req.body;

    if (!toClassId) {
      sendBadRequest(res, "Thiếu thông tin lớp");
      return;
    }

    if (!studentIds || !Array.isArray(studentIds)) {
      sendBadRequest(res, "Thiếu thông tin học sinh");
      return;
    }

    try {
      const result = await this.classService.transferClass(
        actorId,
        userRole,
        toClassId,
        studentIds
      );

      sendSuccess(res, result, "Chuyển lớp cho học sinh thành công");
    } catch (error) {
      console.log(chalk.red("[CLASS] ❌ Transfer class failed"), error);
      next(error);
    }
  }

  async searchClassesInSchool(
    req: Request,
    res: Response,
    next: NextFunction
  ): Promise<void> {
    const { schoolId, query } = req.query;

    console.log("schoolId", schoolId);
    console.log("query", query);

    if (!schoolId?.toString().trim() && !query?.toString().trim()) {
      sendBadRequest(res, "Cần cung cấp thông tin tìm kiếm");
      return;
    }
    try {
      const classes = await this.classService.searchClassesInSchool(
        schoolId?.toString(),
        query?.toString()
      );

      if (!classes || classes.length === 0) {
        sendEmpty(res);
        return;
      }

      sendSuccess(res, classes, "Lấy thông tin lớp thành công");
      return;
    } catch (error) {
      console.log(chalk.red("[CLASS] ❌ Get class by ID failed"), error);
      return next(error);
    }
  }
}

export default ClassController;
