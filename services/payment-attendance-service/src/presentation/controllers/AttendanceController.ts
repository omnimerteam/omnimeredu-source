import { Request, Response } from "express";
import { CreateAttendanceUseCase } from "../../domain/usecases/attendance/CreateAttendanceUseCase";
import { BulkCreateAttendanceRecordsUseCase } from "../../domain/usecases/attendance/BulkCreateAttendanceRecordsUseCase";
import { GetAttendanceByIdUseCase } from "../../domain/usecases/attendance/GetAttendanceByIdUseCase";
import { GetAttendanceRecordsByAttendanceIdUseCase } from "../../domain/usecases/attendance/GetAttendanceRecordsByAttendanceIdUseCase";
import { UpdateAttendanceRecordUseCase } from "../../domain/usecases/attendance/UpdateAttendanceRecordUseCase";
import { CreateAttendanceDto } from "../dtos/CreateAttendanceDto";
import { BulkCreateAttendanceRecordsDto, UpdateAttendanceRecordDto } from "../dtos/AttendanceRecordDto";

export class AttendanceController {
    constructor(
        private createAttendanceUseCase: CreateAttendanceUseCase,
        private bulkCreateRecordsUseCase: BulkCreateAttendanceRecordsUseCase,
        private getAttendanceByIdUseCase: GetAttendanceByIdUseCase,
        private getAttendanceRecordsUseCase: GetAttendanceRecordsByAttendanceIdUseCase,
        private updateAttendanceRecordUseCase: UpdateAttendanceRecordUseCase
    ) { }

    async create(req: Request, res: Response): Promise<void> {
        try {
            const dto: CreateAttendanceDto = req.body;
            const result = await this.createAttendanceUseCase.execute(dto);
            res.status(201).json(result);
        } catch (error: any) {
            res.status(400).json({ error: error.message });
        }
    }

    async bulkCreateRecords(req: Request, res: Response): Promise<void> {
        try {
            const dto: BulkCreateAttendanceRecordsDto = req.body;
            // Ensure attendanceId in body matches param if needed, but DTO has it.
            if (req.params.id && req.params.id !== dto.attendanceId) {
                dto.attendanceId = req.params.id;
            }

            const result = await this.bulkCreateRecordsUseCase.execute(dto);
            res.status(201).json(result);
        } catch (error: any) {
            res.status(400).json({ error: error.message });
        }
    }

    async getById(req: Request, res: Response): Promise<void> {
        try {
            const id = req.params.id;
            const result = await this.getAttendanceByIdUseCase.execute(id);
            if (!result) {
                res.status(404).json({ error: "Attendance not found" });
                return;
            }
            res.status(200).json(result);
        } catch (error: any) {
            res.status(400).json({ error: error.message });
        }
    }

    async getRecords(req: Request, res: Response): Promise<void> {
        try {
            const attendanceId = req.params.id;
            const result = await this.getAttendanceRecordsUseCase.execute(attendanceId);
            res.status(200).json(result);
        } catch (error: any) {
            res.status(400).json({ error: error.message });
        }
    }

    async updateRecord(req: Request, res: Response): Promise<void> {
        try {
            const id = req.params.recordId;
            const dto: UpdateAttendanceRecordDto = req.body;
            const result = await this.updateAttendanceRecordUseCase.execute(id, dto);
            res.status(200).json(result);
        } catch (error: any) {
            res.status(400).json({ error: error.message });
        }
    }
}
