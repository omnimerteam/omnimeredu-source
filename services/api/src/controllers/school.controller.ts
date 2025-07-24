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
        sendNotFound(res);
        return;
      }
      console.log(chalk.green("[SCHOOL] Get all schools"));
      sendSuccess(res, schools, "Get all schools successfully");
    } catch (error) {
      console.log(chalk.red("[SCHOOL] Error getting all schools"));
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
        sendNotFound(res);
        return;
      }
      console.log(chalk.green("[SCHOOL] Get School by ID successfully"));
      sendSuccess(res, school, "Get school by ID successfully");
    } catch (error) {
      console.log(chalk.red("[SCHOOL] Error getting schoold by ID"));
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
      if (!name && !code) {
        sendEmpty(res, "Name or code query parameter is required");
        res
          .status(400)
          .json({ message: "Name or code query parameter is required" });
        return;
      }
      const school = await this.schoolService.getSchoolByNameOrCode(
        name as string,
        code as string,
        userId,
        userRole
      );
      if (!school) {
        sendNotFound(res);
        return;
      }
      console.log(chalk.green("[SCHOOL] Get school by name or code successfully"));
      sendSuccess(res, school, "Get school by name or code successfully");
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
      if (!schoolData) {
        sendEmpty(res, "School data is required");
        return;
      }
      const newSchool = await this.schoolService.createSchool(schoolData, userId, userRole);
      console.log(chalk.green("[SCHOOL] Create school successfully"));
      sendCreated(res, newSchool, "School created successfully");
    } catch (error) {
      console.log(chalk.red("[SCHOOL] Error creating school"));
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
        sendNotFound(res);
        return;
      }
      console.log(chalk.green("[SCHOOL] Update school successfully"));
      sendSuccess(res, updatedSchool, "School updated successfully");
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
        sendNotFound(res);
        return;
      }
      console.log(chalk.green("[SCHOOL] Delete school successfully"));
      sendSuccess(res, null, "School deleted successfully");
    } catch (error) {
      console.log(chalk.red("[SCHOOL] Error deleting school"));
      return next(error);
    }
  }
}
//ở đây chỉ export ra 1 class duy nhất, không cần phải export từng hàm
export default SchoolController;
