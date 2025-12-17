import { IAttendanceRepository } from "../../repositories/IAttendanceRepository";
import { IAttendanceRecordRepository } from "../../repositories/IAttendanceRecordRepository";
import { AttendanceRecord } from "../../entities/AttendanceRecord";

export interface QRPayload {
  attendanceId: string;
  timestamp: string;
  dynamicCode: string;
}

export interface VerifyQRAttendanceDto {
  qrData: string; // Base64 encoded QR payload
  studentId: string;
  dynamicCode?: string; // Optional: verify dynamic code entered by user
}

export interface VerifyQRAttendanceResult {
  success: boolean;
  record?: AttendanceRecord;
  message: string;
}

/**
 * Verify QR Attendance Use Case
 * Handles QR code scanning for student attendance
 */
export class VerifyQRAttendanceUseCase {
  // QR code validity in minutes
  private readonly QR_VALIDITY_MINUTES = 3;

  constructor(
    private attendanceRepository: IAttendanceRepository,
    private attendanceRecordRepository: IAttendanceRecordRepository
  ) {}

  async execute(dto: VerifyQRAttendanceDto): Promise<VerifyQRAttendanceResult> {
    try {
      // Decode QR data
      const payload = this.decodeQRPayload(dto.qrData);

      // Verify timestamp (QR should not be expired)
      const qrTimestamp = new Date(payload.timestamp);
      const now = new Date();
      const diffMinutes = (now.getTime() - qrTimestamp.getTime()) / (1000 * 60);

      if (diffMinutes > this.QR_VALIDITY_MINUTES) {
        return {
          success: false,
          message: "QR code has expired. Please request a new QR code.",
        };
      }

      if (diffMinutes < 0) {
        return {
          success: false,
          message: "Invalid QR code timestamp.",
        };
      }

      // Verify dynamic code if provided
      if (dto.dynamicCode && dto.dynamicCode !== payload.dynamicCode) {
        return {
          success: false,
          message: "Invalid verification code.",
        };
      }

      // Verify attendance exists
      const attendance = await this.attendanceRepository.findById(
        payload.attendanceId
      );
      if (!attendance) {
        return {
          success: false,
          message: "Attendance session not found.",
        };
      }

      // Check if student already has a record
      const existingRecords =
        await this.attendanceRecordRepository.findByAttendanceId(
          payload.attendanceId
        );
      const existingRecord = existingRecords.find(
        (r) => r.studentId === dto.studentId
      );

      if (existingRecord) {
        // Update existing record to Present
        if (existingRecord.status === "Present") {
          return {
            success: true,
            record: existingRecord,
            message: "Attendance already marked as present.",
          };
        }

        existingRecord.status = "Present";
        existingRecord.note = `Checked in via QR at ${new Date().toISOString()}`;
        const updatedRecord = await this.attendanceRecordRepository.update(
          existingRecord
        );

        return {
          success: true,
          record: updatedRecord,
          message: "Attendance marked successfully via QR code.",
        };
      } else {
        // Create new record
        const newRecord = new AttendanceRecord(
          "",
          dto.studentId,
          payload.attendanceId,
          "Present",
          `Checked in via QR at ${new Date().toISOString()}`
        );
        const createdRecord = await this.attendanceRecordRepository.create(
          newRecord
        );

        return {
          success: true,
          record: createdRecord,
          message: "Attendance marked successfully via QR code.",
        };
      }
    } catch (error: any) {
      return {
        success: false,
        message: error.message || "Failed to verify QR code.",
      };
    }
  }

  /**
   * Decode base64 QR payload
   */
  private decodeQRPayload(qrData: string): QRPayload {
    try {
      const decoded = Buffer.from(qrData, "base64").toString("utf-8");
      const payload = JSON.parse(decoded) as QRPayload;

      if (!payload.attendanceId || !payload.timestamp || !payload.dynamicCode) {
        throw new Error("Invalid QR code format");
      }

      return payload;
    } catch (error) {
      throw new Error("Failed to decode QR code. Please scan a valid QR code.");
    }
  }
}
