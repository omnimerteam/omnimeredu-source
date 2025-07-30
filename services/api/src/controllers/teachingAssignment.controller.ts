import { Request, Response, NextFunction } from "express";
import chalk from "chalk";
import TeachingAssignmentService from "../services/teachingAssignment.service";
import {
    sendEmpty,
    sendSuccess,
    sendUnauthorized,
    sendNotFound
} from "../utils/ResponseHelper";

class TeachingAssignmentController {
    private readonly teachingAssignmentService: TeachingAssignmentService;
    constructor(TeachingAssignmentService: TeachingAssignmentService) {
        this.teachingAssignmentService = TeachingAssignmentService;
    }

    async getAllTeachingAssignments(req: Request, res: Response, next: NextFunction): Promise<void> {
        try {
            const userId = req.user?.id;
            console.log("userid School", req.user);
            const userRole = req.role;
            if (!userId || !userRole) {
                sendUnauthorized(res);
                return;
            }
            const assignments = await this.teachingAssignmentService.getAllTeachingAssignments(userId, userRole);
            if (!assignments || assignments.length === 0) {
                sendEmpty(res);
                return;
            }
            console.log(chalk.green("[Teaching Asssignment] Get teaching assignments successfully"));
            sendSuccess(res, assignments, "Lấy danh sách phân công giảng dạy thành công");
            return;
        } catch (error) {
            console.log(chalk.red("[Teaching Assignment] Error getting teaching assignments: ", error));
            return next(error);
        }
    }

    async getTeachingAssignmentById(req: Request, res: Response, next: NextFunction): Promise<void> {
        try {
            const userId = req.user?.id;
            const userRole = req.role;
            if (!userId || !userRole) {
                sendUnauthorized(res);
                return;
            }
            const assginmentId = req.params.id;
            const assignment = await this.teachingAssignmentService.getTeachingAssignmentById(assginmentId, userId, userRole);
            if (!assignment) {
                sendNotFound(res);
                return;
            }
            console.log(chalk.green("[Teaching Asssignment] Get teaching assignments by teacher ID successfully"));
            sendSuccess(res, assignment, "Lấy danh sách phân công giảng dạy theo id giáo viên thành công");
            return;
        } catch (error) {
            console.log(chalk.red("[Teaching Assignment] Error getting teaching assignments by teacher ID: ", error));
            return next(error);
        }
    }

    async createTeachingAssignment(req: Request, res: Response, next: NextFunction): Promise<void> {
        try {
            const userId = req.user.id;
            const userRole = req.role;
            if (!userId || !userRole) {
                sendUnauthorized(res);
                return;
            }

            const assignmentData = req.body;
            const assignment = await this.teachingAssignmentService.createTeachingAssignment(assignmentData, userId, userRole);

            console.log(chalk.green("[Teaching Asssignment] Create teaching assignments successfully"));
            sendSuccess(res, assignment, "Thêm một phân công giảng dạy thành công");
            return;
        } catch (error) {
            console.log(chalk.red("[Teaching Assignment] Error creatting teaching assignments: ", error));
            return next(error);
        }
    }

    async updateTeachingAssignment(req: Request, res: Response, next: NextFunction): Promise<void> {
        try {
            const userId = req.user?.id;
            const userRole = req.role;
            if (!userId || !userRole) {
                sendUnauthorized(res);
                return;
            }
            const assignmentId = req.params.id;
            if (!assignmentId) {
                sendNotFound(res);
                return;
            }
            const assignmentData = req.body;
            const assignment = await this.teachingAssignmentService.updateTeachingAssignment(assignmentId, assignmentData, userId, userRole);

            console.log(chalk.green("[Teaching Asssignment] Update teaching assignments successfully"));
            sendSuccess(res, assignment, "Cập nhật phân công giảng dạy thành công");
            return;
        } catch (error) {
            console.log(chalk.red("[Teaching Assignment] Error updatting teaching assignments: ", error));
            return next(error);
        }
    }

    async deleteTeachingAssignment(req: Request, res: Response, next: NextFunction): Promise<void> {
        try {
            const userId = req.user?.id;
            const userRole = req.role;
            if (!userId || !userRole) {
                sendUnauthorized(res);
                return;
            }
            const assignmentId = req.params.id;
            if (!assignmentId) {
                sendNotFound(res);
                return;
            }
            const assignment = await this.teachingAssignmentService.deleteTeachingAssignment(assignmentId, userId, userRole);
            console.log(chalk.green("[Teaching Asssignment] Delete teaching assignments successfully"));
            sendSuccess(res, assignment, "Xóa phân công giảng dạy thành công");
            return;
        } catch (error) {
            console.log(chalk.red("[Teaching Assignment] Error deletting teaching assignments: ", error));
            return next(error);
        }
    }
}
export default TeachingAssignmentController;