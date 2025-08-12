import { Request, Response, NextFunction } from 'express';
import chalk from 'chalk';
import DetailsRecordService from '../services/detailsRecord.service.js';
import {
    sendSuccess, sendUnauthorized,
    sendNotFound, sendEmpty
} from '../utils/ResponseHelper';

class DetailsRecordController {
    private readonly detailsRecordService: DetailsRecordService;
    constructor(detailsRecordService: DetailsRecordService) {
        this.detailsRecordService = detailsRecordService;
    }

    async getAllDetailsRecords(req: Request, res: Response, next: NextFunction): Promise<void> {
        try {
            const actorId = req.user?.id?.toString();
            const userRole = req.role;
            if (!actorId || !userRole) {
                sendUnauthorized(res);
                return;
            }
            const records = await this.detailsRecordService.getAllDetailsRecords(actorId, userRole);
            if (records.length === 0) {
                sendEmpty(res);
                return;
            }
            console.log(chalk.green("[Details Record] Getting all details records successfully"));
            sendSuccess(res, records, "Lấy danh sách bản ghi thành công");
        } catch (error) {
            console.log(chalk.red("[Details Record] Error getting all details records: ", error));
            return next(error);
        }
    }
    async getDetailsRecordById(req: Request, res: Response, next: NextFunction): Promise<void> {
        try {
            const actorId = req.user?.id?.toString();
            const userRole = req.role;
            if (!actorId || !userRole) {
                sendUnauthorized(res);
                return;
            }
            const recordId = req.params.id;
            const record = await this.detailsRecordService.getDetailsRecordById(recordId, actorId, userRole);
            if (!record) {
                sendNotFound(res);
                return;
            }
            console.log(chalk.green("[Details Record] Getting detail record by ID successfully"));
            sendSuccess(res, record, "Lấy bản ghi theo ID thành công");
        } catch (error) {
            console.log(chalk.red("[Details Record] Error getting detail record by ID: ", error));
            return next(error);
        }
    }

    async createDetailsRecord(req: Request, res: Response, next: NextFunction): Promise<void> {
        try {
            const actorId = req.user?.id?.toString();
            const userRole = req.role;
            if (!actorId || !userRole) {
                sendUnauthorized(res);
                return;
            }
            const recordData = req.body;
            const record = await this.detailsRecordService.createDetailsRecord(recordData, actorId, userRole);
            console.log(chalk.green("[Details Record] Create detail record successfully"));
            sendSuccess(res, record, "Thêm mới bản ghi thành công");
        } catch (error) {
            console.log(chalk.red("[Details Record] Error creatting detail record: ", error));
            return next(error);
        }
    }

    async updateDetailsRecord(req: Request, res: Response, next: NextFunction): Promise<void> {
        try {
            const actorId = req.user?.id?.toString();
            const schoolId = req.user?.schoolId?.toString();
            const userRole = req.role;
            if (!actorId || !userRole) {
                sendUnauthorized(res);
                return;
            }
            const recordId = req.params.id;
            const recordData = req.body;
            const record = await this.detailsRecordService.updateDetailsRecord(recordId, recordData, schoolId, actorId, userRole);
            console.log(chalk.green("[Details Record] Update detail record successfully"));
            sendSuccess(res, record, "Chỉnh sủa bản ghi thành công");
        } catch (error) {
            console.log(chalk.red("[Details Record] Error updatting detail record: ", error));
            return next(error);
        }
    }

    async deleteDetailsRecord(req: Request, res: Response, next: NextFunction): Promise<void> {
        try {
            const actorId = req.user?.id?.toString();
            const schoolId = req.user?.schoolId?.toString();
            const userRole = req.role;
            if (!actorId || !userRole) {
                sendUnauthorized(res);
                return;
            }
            const recordId = req.params.id;
            await this.detailsRecordService.deleteDetailsRecord(recordId, schoolId, actorId, userRole);
            console.log(chalk.green("[Details Record] Delete detail record successfully"));
            sendSuccess(res, {}, "Xoá bản ghi thành công");
        } catch (error) {
            console.log(chalk.red("[Details Record] Error deleting detail record: ", error));
            return next(error);
        }
    }
}
export default DetailsRecordController;