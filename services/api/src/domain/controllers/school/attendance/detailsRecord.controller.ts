import { Request, Response, NextFunction } from "express";
import chalk from "chalk";
import { DetailsRecordService } from "../../../services";
import {
  sendSuccess,
  sendUnauthorized,
  sendNotFound,
  sendEmpty,
} from "../../../../common/utils/ResponseHelper";

class DetailsRecordController {
  private readonly detailsRecordService: DetailsRecordService;
  constructor(detailsRecordService: DetailsRecordService) {
    this.detailsRecordService = detailsRecordService;
  }

  async getAllDetailsRecords(
    req: Request,
    res: Response,
    next: NextFunction
  ): Promise<void> {
    try {
      const actorId = req.user?.id;
      const userRole = req.role;
      if (!actorId || !userRole) {
        sendUnauthorized(res);
        return;
      }
      const records = await this.detailsRecordService.getAllDetailsRecords(
        actorId,
        userRole
      );
      if (records.length === 0) {
        sendEmpty(res);
        return;
      }
      console.log(
        chalk.green("[DETAILS RECORD] Getting all details records successfully")
      );
      sendSuccess(res, records, "Lấy danh sách bản ghi thành công");
    } catch (error) {
      console.log(
        chalk.red("[DETAILS RECORD] Error getting all details records: ", error)
      );
      return next(error);
    }
  }

  async getAttendanceRecordsById(
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
    const attendanceId = req.params.attendanceId;

    try {
      const records = await this.detailsRecordService.getAttendanceRecordsById(
        actorId,
        userRole,
        attendanceId
      );
      if (records.length === 0) {
        sendEmpty(res);
        return;
      }

      sendSuccess(res, records, "Lấy danh sách bản ghi thành công");
    } catch (error) {
      console.log(
        chalk.red(
          "[DETAILS RECORD] Error getting attendance details records: ",
          error
        )
      );
      return next(error);
    }
  }

  async getDetailsRecordById(
    req: Request,
    res: Response,
    next: NextFunction
  ): Promise<void> {
    try {
      const actorId = req.user?.id;
      const userRole = req.role;
      if (!actorId || !userRole) {
        sendUnauthorized(res);
        return;
      }
      const recordId = req.params.id;
      const record = await this.detailsRecordService.getDetailsRecordById(
        recordId,
        actorId,
        userRole
      );
      if (!record) {
        sendNotFound(res);
        return;
      }
      console.log(
        chalk.green("[DETAILS RECORD] Getting detail record by ID successfully")
      );
      sendSuccess(res, record, "Lấy bản ghi theo ID thành công");
    } catch (error) {
      console.log(
        chalk.red("[DETAILS RECORD] Error getting detail record by ID: ", error)
      );
      return next(error);
    }
  }

  async createDetailsRecord(
    req: Request,
    res: Response,
    next: NextFunction
  ): Promise<void> {
    try {
      const actorId = req.user?.id;
      const userRole = req.role;
      if (!actorId || !userRole) {
        sendUnauthorized(res);
        return;
      }
      const recordData = req.body;
      const record = await this.detailsRecordService.createDetailsRecord(
        recordData,
        actorId,
        userRole
      );
      console.log(
        chalk.green("[DETAILS RECORD] Create detail record successfully")
      );
      sendSuccess(res, record, "Thêm mới bản ghi thành công");
    } catch (error) {
      console.log(
        chalk.red("[DETAILS RECORD] Error creatting detail record: ", error)
      );
      return next(error);
    }
  }

  async updateDetailsRecord(
    req: Request,
    res: Response,
    next: NextFunction
  ): Promise<void> {
    try {
      const actorId = req.user?.id;
      const schoolId = req.user?.schoolId?.toString();
      const userRole = req.role;
      if (!actorId || !userRole) {
        sendUnauthorized(res);
        return;
      }
      const recordId = req.params.id;
      const recordData = req.body;
      const record = await this.detailsRecordService.updateDetailsRecord(
        recordId,
        recordData,
        schoolId,
        actorId,
        userRole
      );
      console.log(
        chalk.green("[DETAILS RECORD] Update detail record successfully")
      );
      sendSuccess(res, record, "Chỉnh sủa bản ghi thành công");
    } catch (error) {
      console.log(
        chalk.red("[DETAILS RECORD] Error updatting detail record: ", error)
      );
      return next(error);
    }
  }

  async updateStatusDetailRecord(
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
    const recordId = req.params.id;
    const { status, note } = req.body;

    try {
      const record = await this.detailsRecordService.updateStatusDetailRecord(
        schoolId,
        actorId,
        userRole,
        recordId,
        status,
        note
      );
      sendSuccess(res, record, "Chỉnh sủa bản ghi thành công");
    } catch (error) {
      console.log(
        chalk.red(
          "[DETAILS RECORD] Error updating status detail record: ",
          error
        )
      );
      return next(error);
    }
  }

  async deleteDetailsRecord(
    req: Request,
    res: Response,
    next: NextFunction
  ): Promise<void> {
    try {
      const actorId = req.user?.id;
      const schoolId = req.user?.schoolId?.toString();
      const userRole = req.role;
      if (!actorId || !userRole) {
        sendUnauthorized(res);
        return;
      }
      const recordId = req.params.id;
      await this.detailsRecordService.deleteDetailsRecord(
        recordId,
        schoolId,
        actorId,
        userRole
      );
      console.log(
        chalk.green("[DETAILS RECORD] Delete detail record successfully")
      );
      sendSuccess(res, {}, "Xoá bản ghi thành công");
    } catch (error) {
      console.log(
        chalk.red("[DETAILS RECORD] Error deleting detail record: ", error)
      );
      return next(error);
    }
  }
}
export default DetailsRecordController;
