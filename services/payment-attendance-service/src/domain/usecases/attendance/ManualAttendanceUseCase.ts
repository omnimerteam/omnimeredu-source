import { IAttendanceRepository } from "../../repositories/IAttendanceRepository";
import { IAttendanceRecordRepository } from "../../repositories/IAttendanceRecordRepository";
import { AttendanceRecord } from "../../entities/AttendanceRecord";

export type AttendanceStatus =
  | "Present"
  | "AbsentWithLeave"
  | "Absent"
  | "Late"
  | "LeftEarly";

export interface ManualAttendanceDto {
  attendanceId: string;
  studentId: string;
  status: AttendanceStatus;
  note?: string;
}

export interface BulkManualAttendanceDto {
  attendanceId: string;
  records: {
    studentId: string;
    status: AttendanceStatus;
    note?: string;
  }[];
}

/**
 * Manual Attendance Use Case
 * Allows teachers/admins to manually mark attendance for individual or multiple students
 */
export class ManualAttendanceUseCase {
  constructor(
    private attendanceRepository: IAttendanceRepository,
    private attendanceRecordRepository: IAttendanceRecordRepository
  ) {}

  /**
   * Mark attendance for a single student
   */
  async markSingleStudent(dto: ManualAttendanceDto): Promise<AttendanceRecord> {
    // Verify attendance exists
    const attendance = await this.attendanceRepository.findById(
      dto.attendanceId
    );
    if (!attendance) {
      throw new Error("Attendance session not found");
    }

    // Find existing record for this student
    const existingRecords =
      await this.attendanceRecordRepository.findByAttendanceId(
        dto.attendanceId
      );
    const existingRecord = existingRecords.find(
      (r) => r.studentId === dto.studentId
    );

    if (existingRecord) {
      // Update existing record
      existingRecord.status = dto.status;
      if (dto.note !== undefined) {
        existingRecord.note = dto.note;
      }
      return await this.attendanceRecordRepository.update(existingRecord);
    } else {
      // Create new record
      const newRecord = new AttendanceRecord(
        "",
        dto.studentId,
        dto.attendanceId,
        dto.status,
        dto.note
      );
      return await this.attendanceRecordRepository.create(newRecord);
    }
  }

  /**
   * Mark attendance for multiple students at once
   */
  async markMultipleStudents(
    dto: BulkManualAttendanceDto
  ): Promise<AttendanceRecord[]> {
    // Verify attendance exists
    const attendance = await this.attendanceRepository.findById(
      dto.attendanceId
    );
    if (!attendance) {
      throw new Error("Attendance session not found");
    }

    // Get existing records
    const existingRecords =
      await this.attendanceRecordRepository.findByAttendanceId(
        dto.attendanceId
      );
    const existingRecordMap = new Map(
      existingRecords.map((r) => [r.studentId, r])
    );

    const results: AttendanceRecord[] = [];
    const newRecordsToCreate: AttendanceRecord[] = [];

    for (const record of dto.records) {
      const existing = existingRecordMap.get(record.studentId);

      if (existing) {
        // Update existing record
        existing.status = record.status;
        if (record.note !== undefined) {
          existing.note = record.note;
        }
        const updated = await this.attendanceRecordRepository.update(existing);
        results.push(updated);
      } else {
        // Queue for bulk creation
        newRecordsToCreate.push(
          new AttendanceRecord(
            "",
            record.studentId,
            dto.attendanceId,
            record.status,
            record.note
          )
        );
      }
    }

    // Create new records in bulk
    if (newRecordsToCreate.length > 0) {
      const created = await this.attendanceRecordRepository.createBulk(
        newRecordsToCreate
      );
      results.push(...created);
    }

    return results;
  }

  /**
   * Update attendance status for a single record by record ID
   */
  async updateRecordStatus(
    recordId: string,
    status: AttendanceStatus,
    note?: string
  ): Promise<AttendanceRecord> {
    const record = await this.attendanceRecordRepository.findById(recordId);
    if (!record) {
      throw new Error("Attendance record not found");
    }

    record.status = status;
    if (note !== undefined) {
      record.note = note;
    }

    return await this.attendanceRecordRepository.update(record);
  }
}
