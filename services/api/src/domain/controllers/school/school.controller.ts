import { SchoolService } from "../../services";
import { NextFunction, Request, Response } from "express";
import { ISchool } from "../../models";
import chalk from "chalk";
import {
  sendSuccess,
  sendCreated,
  sendNotFound,
  sendEmpty,
  sendUnauthorized,
  sendBadRequest,
  sendNoContent,
} from "../../../common/utils/ResponseHelper";

class SchoolController {
  private readonly schoolService: SchoolService;

  constructor(SchoolService: SchoolService) {
    this.schoolService = SchoolService;
  }

  async getAllSchools(
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
      const schools = await this.schoolService.getAllSchools(actorId, userRole);
      if (!schools || schools.length === 0) {
        sendEmpty(res);
        return;
      }
      console.log(chalk.green("[SCHOOL] Get all schools successfully"));
      sendSuccess(res, schools, "Lấy danh sách trường học thành công");
    } catch (error) {
      console.log(chalk.red("[SCHOOL] Error getting all schools: ", error));
      return next(error);
    }
  }
  /**
   * Đây là hàm lấy toàn bộ thông tin của trường dành riêng cho SchoolAdmin (SchoolAdmin nào thì chỉ được lấy của người đó)
   * @param req
   * @param res
   * @param next
   * @returns
   */
  async getSchoolDetailForSchoolAdmin(
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
      const schoolId = req.user?.schoolId;

      const school = await this.schoolService.getSchoolDetailForSchoolAdmin(
        schoolId,
        actorId,
        userRole
      );
      if (!school) {
        sendNotFound(res, "Không tìm thấy trường học");
        return;
      }
      console.log(chalk.green("[SCHOOL] Get school by ID successfully"));
      sendSuccess(res, school, "Lấy thông tin trường học theo ID thành công");
    } catch (error) {
      console.log(chalk.red("[SCHOOL] Error getting school by ID: ", error));
      return next(error);
    }
  }

  async searchSchoolByEducationLevel(
    req: Request,
    res: Response,
    next: NextFunction
  ): Promise<void> {
    const { query, educationLevel } = req.query;
    console.log("Query", query);
    console.log("Education Level", educationLevel);
    if (!query?.toString().trim() && !educationLevel?.toString().trim()) {
      sendBadRequest(res, "Cần cung cấp thông tin tìm kiếm");
      return;
    }

    try {
      const schools = await this.schoolService.searchSchoolByEducationLevel(
        educationLevel?.toString(),
        query?.toString()
      );

      if (!schools || schools.length === 0) {
        sendEmpty(res);
        return;
      }

      sendSuccess(res, schools, "Lấy trường học theo tên hoặc mã thành công");
    } catch (error) {
      console.log(
        chalk.red("[SCHOOL] Error getting school by name or code: ", error)
      );
      return next(error);
    }
  }

  async createSchool(
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
      const schoolData: Partial<ISchool> = req.body;
      const newSchool = await this.schoolService.createSchool(
        schoolData,
        actorId,
        userRole
      );
      sendCreated(res, newSchool, "Thêm mới trường học thành công");
    } catch (error) {
      console.log(chalk.red("[SCHOOL] Error creating new school: ", error));
      return next(error);
    }
  }

  async updateSchool(
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
      const schoolId = req.user?.schoolId;
      const schoolData: Partial<ISchool> = req.body;
      const updatedSchool = await this.schoolService.updateSchool(
        schoolId,
        schoolData,
        actorId,
        userRole
      );
      if (!updatedSchool) {
        sendEmpty(res);
        return;
      }

      sendSuccess(
        res,
        updatedSchool,
        "Cập nhật thông tin trường học thành công"
      );
    } catch (error) {
      console.log(chalk.red("[SCHOOL] Error updating school: ", error));
      return next(error);
    }
  }

  async deleteSchool(
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
      const schoolId = req.user?.schoolId;
      const deleted = await this.schoolService.deleteSchool(
        schoolId,
        actorId,
        userRole
      );

      if (!deleted) {
        sendBadRequest(res, "Xóa trường thất bại");
        return;
      }

      sendSuccess(res, null, "Xóa thông tin trường học thành công");
    } catch (error) {
      console.log(chalk.red("[SCHOOL] Error deleting school: ", error));
      return next(error);
    }
  }
}
//ở đây chỉ export ra 1 class duy nhất, không cần phải export từng hàm
export default SchoolController;
