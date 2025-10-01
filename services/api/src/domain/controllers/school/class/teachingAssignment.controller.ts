import { Request, Response, NextFunction } from "express";
import chalk from "chalk";
import { TeachingAssignmentService } from "../../../services";
import {
  sendEmpty,
  sendSuccess,
  sendUnauthorized,
  sendNotFound,
  sendBadRequest,
} from "../../../../common/utils/ResponseHelper";
import { buildQueryOptions } from "../../../../common/utils/buildQueryOptions";

class TeachingAssignmentController {
  private readonly teachingAssignmentService: TeachingAssignmentService;
  constructor(TeachingAssignmentService: TeachingAssignmentService) {
    this.teachingAssignmentService = TeachingAssignmentService;
  }

  async getAllTeachingAssignments(
    req: Request,
    res: Response,
    next: NextFunction
  ): Promise<void> {
    const actorId = req.user?.id;
    const userRole = req.role;
    if (!actorId || !userRole) {
      sendUnauthorized(res);
      return;
    }

    const schoolId = req.user?.schoolId;

    const option = buildQueryOptions(req.query as any);

    try {
      const assignments =
        await this.teachingAssignmentService.getAllTeachingAssignments(
          actorId,
          userRole,
          schoolId,
          option
        );

      if (!assignments || assignments.length === 0) {
        sendEmpty(res);
        return;
      }

      sendSuccess(
        res,
        assignments,
        "Lấy danh sách phân công giảng dạy thành công"
      );
      return;
    } catch (error) {
      console.log(
        chalk.red(
          "[TEACHING ASSIGNMENT] Error getting all teaching assignments: ",
          error
        )
      );
      return next(error);
    }
  }

  async getTeachingAssignmentById(
    req: Request,
    res: Response,
    next: NextFunction
  ): Promise<void> {
    const actorId = req.user?.id;
    const userRole = req.role;
    if (!actorId || !userRole) {
      sendUnauthorized(res);
      return;
    }
    const assignmentId = req.params.id;

    try {
      const assignment =
        await this.teachingAssignmentService.getTeachingAssignmentById(
          assignmentId,
          actorId,
          userRole
        );
      if (!assignment) {
        sendNotFound(res);
        return;
      }

      sendSuccess(
        res,
        assignment,
        "Lấy danh sách phân công giảng dạy thành công"
      );
      return;
    } catch (error) {
      console.log(
        chalk.red(
          "[TEACHING ASSIGNMENT] Error getting teaching assignments by ID: ",
          error
        )
      );
      return next(error);
    }
  }

  async getTeachingAssignmentByTeacherClassAndSchool(
    req: Request,
    res: Response,
    next: NextFunction
  ): Promise<void> {
    const actorId = req.user?.id;
    const userRole = req.role;
    if (!actorId || !userRole) {
      sendUnauthorized(res);
      return;
    }
    const teacherId = req.params.teacherId;
    const schoolId = req.params.schoolId;
    const classId = req.params.classId;
    try {
      const assignment =
        await this.teachingAssignmentService.getTeachingAssignmentByTeacherClassAndSchool(
          actorId,
          userRole,
          teacherId,
          schoolId,
          classId
        );

      if (!assignment) {
        sendEmpty(res, "Không tìm thấy dữ liệu");
        return;
      }

      sendSuccess(res, assignment, "Lấy phân công giảng dạy thành công");
      return;
    } catch (error) {
      console.log(
        chalk.red(
          "[TEACHING ASSIGNMENT] Error getting teaching assignments by teacher, school, class ID: ",
          error
        )
      );
      return next(error);
    }
  }

  async createTeachingAssignment(
    req: Request,
    res: Response,
    next: NextFunction
  ): Promise<void> {
    const actorId = req.user?.id;
    const schoolId = req.user?.schoolId;
    const userRole = req.role;
    if (!actorId || !userRole) {
      sendUnauthorized(res);
      return;
    }

    const assignmentData = req.body;
    try {
      const assignment =
        await this.teachingAssignmentService.createTeachingAssignment(
          assignmentData,
          schoolId,
          actorId,
          userRole
        );

      sendSuccess(res, assignment, "Thêm một phân công giảng dạy thành công");
      return;
    } catch (error) {
      console.log(
        chalk.red(
          "[TEACHING ASSIGNMENT] Error creatting teaching assignments: ",
          error
        )
      );
      return next(error);
    }
  }

  async updateTeachingAssignment(
    req: Request,
    res: Response,
    next: NextFunction
  ): Promise<void> {
    const actorId = req.user?.id;
    const schoolId = req.user?.schoolId;
    const userRole = req.role;
    if (!actorId || !userRole) {
      sendUnauthorized(res);
      return;
    }
    const assignmentId = req.params.id;

    if (!assignmentId) {
      sendBadRequest(res);
      return;
    }
    const assignmentData = req.body;

    try {
      const assignment =
        await this.teachingAssignmentService.updateTeachingAssignment(
          assignmentId,
          assignmentData,
          schoolId,
          actorId,
          userRole
        );

      sendSuccess(res, assignment, "Cập nhật phân công giảng dạy thành công");
      return;
    } catch (error) {
      console.log(
        chalk.red(
          "[TEACHING ASSIGNMENT] Error updatting teaching assignments: ",
          error
        )
      );
      return next(error);
    }
  }

  async deleteTeachingAssignment(
    req: Request,
    res: Response,
    next: NextFunction
  ): Promise<void> {
    const actorId = req.user?.id;
    const schoolId = req.user?.schoolId?.toString();
    const userRole = req.role;
    if (!actorId || !userRole) {
      sendUnauthorized(res);
      return;
    }
    const assignmentId = req.params.id;
    if (!assignmentId) {
      sendBadRequest(res);
      return;
    }

    try {
      const assignment =
        await this.teachingAssignmentService.deleteTeachingAssignment(
          assignmentId,
          schoolId,
          actorId,
          userRole
        );

      sendSuccess(res, assignment, "Xóa phân công giảng dạy thành công");
      return;
    } catch (error) {
      console.log(
        chalk.red(
          "[TEACHING ASSIGNMENT] Error deletting teaching assignments: ",
          error
        )
      );
      return next(error);
    }
  }

  async getAllAssignmentForTeacherInSchool(
    req: Request,
    res: Response,
    next: NextFunction
  ): Promise<void> {
    const actorId = req.user?.id;
    const userRole = req.role;
    if (!actorId || !userRole) {
      sendUnauthorized(res);
      return;
    }
    const teacherId = req.params.teacherId;
    const schoolId = req.params.schoolId;
    try {
      const assignment =
        await this.teachingAssignmentService.getAllAssignmentForTeacherInSchool(
          actorId,
          userRole,
          teacherId,
          schoolId
        );

      if (!assignment) {
        sendEmpty(res, "Không tìm thấy dữ liệu");
        return;
      }

      sendSuccess(res, assignment, "Lấy phân công giảng dạy thành công");
      return;
    } catch (error) {
      console.log(
        chalk.red(
          "[TEACHING ASSIGNMENT] Error getting ALL teaching assignments for teacher in school: ",
          error
        )
      );
      return next(error);
    }
  }
}
export default TeachingAssignmentController;
