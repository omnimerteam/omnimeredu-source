import SchoolService from "../services/school.services";
import { NextFunction, Request, Response } from "express";
import { ISchool } from "../models/School";
import chalk from "chalk";
import {
  sendSuccess,
  sendCreated,
  sendNotFound,
  sendEmpty,
  sendUnauthorized
} from "../utils/ResponseHelper";

class SchoolController {
  private readonly schoolService: SchoolService;

  constructor(SchoolService: SchoolService) {
    this.schoolService = SchoolService;
  }

  async getAllSchools(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const userId = req.user?.id;
      const userRole = req.role;
      if (!userRole || !userId) {
        sendUnauthorized(res);
        return;
      }
      const schools = await this.schoolService.getAllSchools(userId, userRole);
      if (!schools || schools.length === 0) {
        sendEmpty(res);
        return;
      }
      console.log(chalk.green("[SCHOOL] Get all schools successfully"));
      sendSuccess(res, schools, "Lấy danh sách trường học thành công");
    } catch (error) {
      console.log(chalk.red("[SCHOOL] Erorr getting all schools"));
      return next(error);
    }
  }

  async getSchoolById(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const userId = req.user?.id;
      const userRole = req.role;
      if (!userRole || !userId) {
        sendUnauthorized(res);
        return;
      }
      const schoolId = req.params.id;
      const school = await this.schoolService.getSchoolById(schoolId, userId, userRole);
      if (!school) {
        sendEmpty(res);
        return;
      }
      console.log(chalk.green("[SCHOOL] Get school by ID successfully"));
      sendSuccess(res, school, "Lấy thông tin trường học theo ID thành công");
    } catch (error) {
      console.log(chalk.red("[SCHOOL] Error getting school by ID"));
      return next(error);
    }
  }

  async getSchoolByNameOrCode(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      // Ở hàm này sẽ lấy giá trị từ query trực tiếp trên url
      const userId = req.user?.id;
      const userRole = req.role;
      if (!userRole || !userId) {
        sendUnauthorized(res);
        return;
      }
      const { name, code } = req.query;
      const school = await this.schoolService.getSchoolByNameOrCode(
        name as string,
        code as string,
        userId,
        userRole
      );
      if (!school) {
        sendEmpty(res);
        return;
      }
      console.log(chalk.green("[SCHOOL] Get school by name or code successfully"));
      sendSuccess(res, school, "Lấy trường học theo tên hoặc mã thành công");
    } catch (error) {
      console.log(chalk.red("[SCHOOL] Error getting school by name or code"));
      return next(error);
    }
  }

  async createSchool(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const userId = req.user?.id;
      const userRole = req.role;
      if (!userRole || !userId) {
        sendUnauthorized(res);
        return;
      }
      const schoolData: Partial<ISchool> = req.body;
      const newSchool = await this.schoolService.createSchool(schoolData, userId, userRole);
      console.log(chalk.green("[SCHOOL] Create new school successfully"));
      sendCreated(res, newSchool, "Thêm mới trường học thành công");
    } catch (error) {
      console.log(chalk.red("[SCHOOL] Error creating new school"));
      return next(error);
    }
  }

  async updateSchool(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const userId = req.user?.id;
      const userRole = req.role;
      if (!userRole || !userId) {
        sendUnauthorized(res);
        return;
      }
      const schoolId = req.params.id;
      const schoolData: Partial<ISchool> = req.body;
      const updatedSchool = await this.schoolService.updateSchool(
        schoolId,
        schoolData,
        userId,
        userRole
      );
      if (!updatedSchool) {
        sendEmpty(res);
        return;
      }
      console.log(chalk.green("[SCHOOL] Update school successfully"));
      sendSuccess(res, updatedSchool, "Cập nhật thông tin trường học thành công");
    } catch (error) {
      console.log(chalk.red("[SCHOOL] Error updating school"));
      return next(error);
    }
  }

  async deleteSchool(req: Request, res: Response, next: NextFunction): Promise<void> {
    try {
      const userId = req.user?.id;
      const userRole = req.role;
      if (!userRole || !userId) {
        sendUnauthorized(res);
        return;
      }
      const schoolId = req.params.id;
      const deleted = await this.schoolService.deleteSchool(schoolId, userId, userRole);
      if (!deleted) {
        sendEmpty(res);
        return;
      }
      console.log(chalk.green("[SCHOOL] Delete school successfully"));
      sendSuccess(res, null, "Xóa thông tin trường học thành công");
    } catch (error) {
      console.log(chalk.red("[SCHOOL] Error deleting school"));
      return next(error);
    }
  }
}
//ở đây chỉ export ra 1 class duy nhất, không cần phải export từng hàm
export default SchoolController;
