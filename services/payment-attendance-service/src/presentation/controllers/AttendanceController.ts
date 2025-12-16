import { Request, Response } from "express";
import { CreateAttendanceUseCase } from "../../domain/usecases/attendance/CreateAttendanceUseCase";
import { BulkCreateAttendanceRecordsUseCase } from "../../domain/usecases/attendance/BulkCreateAttendanceRecordsUseCase";
import { GetAttendanceByIdUseCase } from "../../domain/usecases/attendance/GetAttendanceByIdUseCase";
import { GetAttendanceRecordsByAttendanceIdUseCase } from "../../domain/usecases/attendance/GetAttendanceRecordsByAttendanceIdUseCase";
import { UpdateAttendanceRecordUseCase } from "../../domain/usecases/attendance/UpdateAttendanceRecordUseCase";
import { GenerateQRCodeUseCase } from "../../domain/usecases/attendance/GenerateQRCodeUseCase";
import { InitializeClassAttendanceUseCase } from "../../domain/usecases/attendance/InitializeClassAttendanceUseCase";
import { ManualAttendanceUseCase } from "../../domain/usecases/attendance/ManualAttendanceUseCase";
import { VerifyQRAttendanceUseCase } from "../../domain/usecases/attendance/VerifyQRAttendanceUseCase";
import { CreateAttendanceDto } from "../dtos/CreateAttendanceDto";
import {
  BulkCreateAttendanceRecordsDto,
  UpdateAttendanceRecordDto,
} from "../dtos/AttendanceRecordDto";
import {
  InitializeClassAttendanceDto,
  ManualAttendanceDto,
  BulkManualAttendanceDto,
  UpdateAttendanceStatusDto,
  VerifyQRAttendanceDto,
} from "../dtos/AttendanceOperationsDto";
import { AuthenticatedRequest } from "../middleware/auth";

/**
 * Response utility for consistent API responses
 */
const sendSuccess = (
  res: Response,
  message: string,
  data: any,
  statusCode: number = 200
) => {
  res.status(statusCode).json({
    success: true,
    message,
    data,
  });
};

const sendError = (
  res: Response,
  message: string,
  statusCode: number = 400,
  error?: any
) => {
  res.status(statusCode).json({
    success: false,
    message,
    error: error?.message || error,
  });
};

export class AttendanceController {
  constructor(
    private createAttendanceUseCase: CreateAttendanceUseCase,
    private bulkCreateRecordsUseCase: BulkCreateAttendanceRecordsUseCase,
    private getAttendanceByIdUseCase: GetAttendanceByIdUseCase,
    private getAttendanceRecordsUseCase: GetAttendanceRecordsByAttendanceIdUseCase,
    private updateAttendanceRecordUseCase: UpdateAttendanceRecordUseCase,
    private generateQRCodeUseCase: GenerateQRCodeUseCase,
    private initializeClassAttendanceUseCase?: InitializeClassAttendanceUseCase,
    private manualAttendanceUseCase?: ManualAttendanceUseCase,
    private verifyQRAttendanceUseCase?: VerifyQRAttendanceUseCase
  ) {}

  /**
   * Create a new attendance session
   * POST /api/attendance
   */
  async create(req: Request, res: Response): Promise<void> {
    try {
      const dto: CreateAttendanceDto = req.body;
      dto.date = new Date(dto.date);
      const result = await this.createAttendanceUseCase.execute(dto);
      sendSuccess(res, "Attendance created successfully", result, 201);
    } catch (error: any) {
      sendError(res, error.message, 400, error);
    }
  }

  /**
   * Initialize attendance for a class with default records
   * POST /api/attendance/initialize
   */
  async initializeClassAttendance(req: Request, res: Response): Promise<void> {
    try {
      if (!this.initializeClassAttendanceUseCase) {
        sendError(res, "Feature not available", 501);
        return;
      }

      const dto: InitializeClassAttendanceDto = req.body;
      dto.date = new Date(dto.date);

      if (!dto.classId || !dto.schoolId || !dto.studentIds?.length) {
        sendError(res, "classId, schoolId, and studentIds are required", 400);
        return;
      }

      const result = await this.initializeClassAttendanceUseCase.execute(dto);
      sendSuccess(
        res,
        result.isNewAttendance
          ? "Attendance initialized successfully"
          : "Attendance retrieved with updated records",
        result,
        result.isNewAttendance ? 201 : 200
      );
    } catch (error: any) {
      sendError(res, error.message, 400, error);
    }
  }

  /**
   * Bulk create attendance records
   * POST /api/attendance/:id/records/bulk
   */
  async bulkCreateRecords(req: Request, res: Response): Promise<void> {
    try {
      const dto: BulkCreateAttendanceRecordsDto = req.body;
      if (req.params.id && req.params.id !== dto.attendanceId) {
        dto.attendanceId = req.params.id;
      }

      const result = await this.bulkCreateRecordsUseCase.execute(dto);
      sendSuccess(res, "Attendance records created successfully", result, 201);
    } catch (error: any) {
      sendError(res, error.message, 400, error);
    }
  }

  /**
   * Get attendance by ID
   * GET /api/attendance/:id
   */
  async getById(req: Request, res: Response): Promise<void> {
    try {
      const id = req.params.id;
      const result = await this.getAttendanceByIdUseCase.execute(id);
      if (!result) {
        sendError(res, "Attendance not found", 404);
        return;
      }
      sendSuccess(res, "Attendance retrieved successfully", result);
    } catch (error: any) {
      sendError(res, error.message, 400, error);
    }
  }

  /**
   * Get attendance records by attendance ID
   * GET /api/attendance/:id/records
   */
  async getRecords(req: Request, res: Response): Promise<void> {
    try {
      const attendanceId = req.params.id;
      const result = await this.getAttendanceRecordsUseCase.execute(
        attendanceId
      );
      sendSuccess(res, "Attendance records retrieved successfully", result);
    } catch (error: any) {
      sendError(res, error.message, 400, error);
    }
  }

  /**
   * Update single attendance record
   * PATCH /api/attendance/records/:recordId
   */
  async updateRecord(req: Request, res: Response): Promise<void> {
    try {
      const id = req.params.recordId;
      const dto: UpdateAttendanceRecordDto = req.body;
      const result = await this.updateAttendanceRecordUseCase.execute(id, dto);
      sendSuccess(res, "Attendance record updated successfully", result);
    } catch (error: any) {
      const statusCode = error.message.includes("not found") ? 404 : 400;
      sendError(res, error.message, statusCode, error);
    }
  }

  /**
   * Mark attendance manually for a single student
   * POST /api/attendance/:id/manual
   */
  async markManualAttendance(req: Request, res: Response): Promise<void> {
    try {
      if (!this.manualAttendanceUseCase) {
        sendError(res, "Feature not available", 501);
        return;
      }

      const dto: ManualAttendanceDto = {
        ...req.body,
        attendanceId: req.params.id,
      };

      if (!dto.studentId || !dto.status) {
        sendError(res, "studentId and status are required", 400);
        return;
      }

      const result = await this.manualAttendanceUseCase.markSingleStudent(dto);
      sendSuccess(res, "Manual attendance marked successfully", result);
    } catch (error: any) {
      const statusCode = error.message.includes("not found") ? 404 : 400;
      sendError(res, error.message, statusCode, error);
    }
  }

  /**
   * Mark attendance manually for multiple students
   * POST /api/attendance/:id/manual/bulk
   */
  async markBulkManualAttendance(req: Request, res: Response): Promise<void> {
    try {
      if (!this.manualAttendanceUseCase) {
        sendError(res, "Feature not available", 501);
        return;
      }

      const dto: BulkManualAttendanceDto = {
        ...req.body,
        attendanceId: req.params.id,
      };

      if (!dto.records?.length) {
        sendError(res, "records array is required and must not be empty", 400);
        return;
      }

      const result = await this.manualAttendanceUseCase.markMultipleStudents(
        dto
      );
      sendSuccess(res, "Bulk manual attendance marked successfully", result);
    } catch (error: any) {
      const statusCode = error.message.includes("not found") ? 404 : 400;
      sendError(res, error.message, statusCode, error);
    }
  }

  /**
   * Update attendance status for a specific record
   * PATCH /api/attendance/records/:recordId/status
   */
  async updateRecordStatus(req: Request, res: Response): Promise<void> {
    try {
      if (!this.manualAttendanceUseCase) {
        sendError(res, "Feature not available", 501);
        return;
      }

      const recordId = req.params.recordId;
      const dto: UpdateAttendanceStatusDto = req.body;

      if (!dto.status) {
        sendError(res, "status is required", 400);
        return;
      }

      const result = await this.manualAttendanceUseCase.updateRecordStatus(
        recordId,
        dto.status,
        dto.note
      );
      sendSuccess(res, "Attendance status updated successfully", result);
    } catch (error: any) {
      const statusCode = error.message.includes("not found") ? 404 : 400;
      sendError(res, error.message, statusCode, error);
    }
  }

  /**
   * Generate QR code for attendance
   * GET /api/attendance/:id/qr
   */
  async generateQRCode(req: Request, res: Response): Promise<void> {
    try {
      const attendanceId = req.params.id;
      const result = await this.generateQRCodeUseCase.execute(attendanceId);
      sendSuccess(res, "QR code generated successfully", result);
    } catch (error: any) {
      if (error.message === "Attendance not found") {
        sendError(res, error.message, 404, error);
      } else {
        sendError(res, error.message, 400, error);
      }
    }
  }

  /**
   * Verify QR code and mark attendance
   * POST /api/attendance/qr/verify
   */
  async verifyQRAttendance(req: Request, res: Response): Promise<void> {
    try {
      if (!this.verifyQRAttendanceUseCase) {
        sendError(res, "Feature not available", 501);
        return;
      }

      const dto: VerifyQRAttendanceDto = req.body;

      if (!dto.qrData || !dto.studentId) {
        sendError(res, "qrData and studentId are required", 400);
        return;
      }

      const result = await this.verifyQRAttendanceUseCase.execute(dto);

      if (result.success) {
        sendSuccess(res, result.message, result.record);
      } else {
        sendError(res, result.message, 400);
      }
    } catch (error: any) {
      sendError(res, error.message, 400, error);
    }
  }
}
