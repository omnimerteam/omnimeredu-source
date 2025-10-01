import { IDetailsRecord } from "../../../models";
import { DefaultLogger } from "../../../../common/utils/DefaultLogger.js";

import {
  DetailsRecordRepository,
  AttendanceRepository,
} from "../../../repositories";
import { HttpError } from "../../../../common/utils/HttpError";
import DateUtils from "../../../../common/utils/DateUtils";
import AppConstant from "../../../../common/configs/app_constant";
import { AttendanceStatusEnum } from "../../../../common/enum/attendanceStatus.enum";

class DetailsRecordService {
  private readonly detailsRecordRepository: DetailsRecordRepository;
  private readonly attendanceRepository: AttendanceRepository;
  private readonly logger: DefaultLogger;
  constructor(
    detailsRecordRepository: DetailsRecordRepository,
    attendanceRepository: AttendanceRepository,
    logger: DefaultLogger
  ) {
    this.detailsRecordRepository = detailsRecordRepository;
    this.attendanceRepository = attendanceRepository;
    this.logger = logger;
  }

  async getAllDetailsRecords(actorId: string, userRole: string) {
    try {
      const records = await this.detailsRecordRepository.findAll();
      await this.logger.log({
        userId: actorId,
        action: "GET_ALL_DETAILS_RECORDS",
        roleSnapshot: userRole,
        metadata: { count: records.length },
      });
      return records;
    } catch (error) {
      await this.logger.log({
        userId: actorId,
        action: "GET_ALL_DETAILS_RECORDS_FAILED",
        roleSnapshot: userRole,
        metadata: { error: (error as Error).message },
      });
      throw error;
    }
  }

  async getAttendanceRecordsById(
    actorId: string,
    userRole: string,
    attendanceId: string
  ) {
    try {
      const records = await this.detailsRecordRepository.findByAttendanceId(
        attendanceId
      );

      await this.logger.log({
        userId: actorId,
        action: "GET_ATTENDANCE_RECORDS_BY_ID",
        roleSnapshot: userRole,
        metadata: { count: records.length },
      });
      return records;
    } catch (error) {
      await this.logger.log({
        userId: actorId,
        action: "GET_ATTENDANCE_RECORDS_BY_ID_FAILED",
        roleSnapshot: userRole,
        metadata: { error: (error as Error).message },
      });
      throw error;
    }
  }

  async getDetailsRecordById(
    recordId: string,
    actorId: string,
    userRole: string
  ) {
    try {
      const record = await this.detailsRecordRepository.findById(recordId);
      await this.logger.log({
        userId: actorId,
        action: "GET_DETAIL_RECORD_BY_ID",
        roleSnapshot: userRole,
        targetId: recordId,
        metadata: { found: !!record },
      });
      return record;
    } catch (error) {
      await this.logger.log({
        userId: actorId,
        action: "GET_DETAIL_RECORD_BY_ID_FAILED",
        roleSnapshot: userRole,
        targetId: recordId,
        metadata: { error: (error as Error).message },
      });
      throw error;
    }
  }

  async createDetailsRecord(
    recordData: Partial<IDetailsRecord>,
    actorId: string,
    userRole: string
  ) {
    try {
      const record = await this.detailsRecordRepository.create(recordData);
      await this.logger.log({
        userId: actorId,
        action: "CREATE_DETAIL_RECORD",
        roleSnapshot: userRole,
        metadata: { found: !!record },
      });
      return record;
    } catch (error) {
      await this.logger.log({
        userId: actorId,
        action: "CREATE_DETAIL_RECORD_FAILED",
        roleSnapshot: userRole,
        metadata: { error: (error as Error).message },
      });
      throw error;
    }
  }
  async updateDetailsRecord(
    recordId: string,
    recordData: Partial<IDetailsRecord>,
    schoolId: string,
    actorId: string,
    userRole: string
  ) {
    try {
      const existingRecord = await this.detailsRecordRepository.findById(
        recordId
      );
      if (!existingRecord)
        throw new HttpError(404, "Không tìm thấy bản ghi theo ID");

      const attendance = await this.attendanceRepository.findById(
        existingRecord.attendanceId.toString()
      );
      if (!attendance)
        throw new HttpError(404, "Không tìm thấy buổi điểm danh liên quan");

      const isSameSchool = schoolId === attendance.schoolId.toString();

      if (userRole !== "SuperAdmin") {
        if (!isSameSchool) {
          throw new HttpError(403, "Bạn không có quyền chỉnh sửa bản ghi này");
        }

        if (userRole === "Teacher") {
          if (
            !DateUtils.isEditableByTeacher(
              attendance.date,
              AppConstant.TEACHER_EDIT_DAYS_LIMIT
            )
          ) {
            throw new HttpError(
              403,
              "Giáo viên chỉ được chỉnh sửa trong vòng 2 ngày kể từ ngày điểm danh"
            );
          }
        }
      }

      const updatedRecord = await this.detailsRecordRepository.update(
        recordId,
        recordData
      );

      await this.logger.log({
        userId: actorId,
        action: "UPDATE_DETAIL_RECORD",
        roleSnapshot: userRole,
        targetId: recordId,
        metadata: { found: !!updatedRecord },
      });

      return updatedRecord;
    } catch (error) {
      await this.logger.log({
        userId: actorId,
        action: "UPDATE_DETAIL_RECORD_FAILED",
        roleSnapshot: userRole,
        targetId: recordId,
        metadata: { error: (error as Error).message },
      });
      throw error;
    }
  }

  async updateStatusDetailRecord(
    schoolId: string,
    actorId: string,
    userRole: string,
    recordId: string,
    status: AttendanceStatusEnum,
    note?: string
  ) {
    try {
      const existingRecord = await this.detailsRecordRepository.findById(
        recordId
      );
      if (!existingRecord)
        throw new HttpError(404, "Không tìm thấy bản ghi theo ID");

      const attendance = await this.attendanceRepository.findById(
        existingRecord.attendanceId.toString()
      );
      if (!attendance)
        throw new HttpError(404, "Không tìm thấy buổi điểm danh liên quan");

      const isSameSchool = schoolId === attendance.schoolId.toString();

      if (userRole !== "SuperAdmin") {
        if (!isSameSchool) {
          throw new HttpError(403, "Bạn không có quyền chỉnh sửa bản ghi này");
        }

        if (userRole === "Teacher") {
          if (
            !DateUtils.isEditableByTeacher(
              attendance.date,
              AppConstant.TEACHER_EDIT_DAYS_LIMIT
            )
          ) {
            throw new HttpError(
              403,
              "Giáo viên chỉ được chỉnh sửa trong vòng 2 ngày kể từ ngày điểm danh"
            );
          }
        }
      }

      const updatedRecord =
        await this.detailsRecordRepository.updateStatusDetailRecord(
          recordId,
          status,
          note
        );

      await this.logger.log({
        userId: actorId,
        action: "UPDATE_STATUS_DETAIL_RECORD",
        roleSnapshot: userRole,
        targetId: recordId,
        metadata: { found: !!updatedRecord },
      });

      return updatedRecord;
    } catch (error) {
      await this.logger.log({
        userId: actorId,
        action: "UPDATE_STATUS_DETAIL_RECORD_FAILED",
        roleSnapshot: userRole,
        targetId: recordId,
        metadata: { error: (error as Error).message },
      });
      throw error;
    }
  }

  async deleteDetailsRecord(
    recordId: string,
    schoolId: string,
    actorId: string,
    userRole: string
  ) {
    try {
      const existingRecord = await this.detailsRecordRepository.findById(
        recordId
      );
      if (!existingRecord)
        throw new HttpError(404, "Không tìm thấy bản ghi theo ID");

      const attendance = await this.attendanceRepository.findById(
        existingRecord.attendanceId.toString()
      );
      if (!attendance)
        throw new HttpError(404, "Không tìm thấy buổi điểm danh liên quan");

      const isSameSchool = schoolId === attendance.schoolId.toString();

      if (userRole !== "SuperAdmin") {
        if (!isSameSchool) {
          throw new HttpError(403, "Bạn không có quyền chỉnh sửa bản ghi này");
        }

        if (userRole === "Teacher") {
          if (
            !DateUtils.isEditableByTeacher(
              attendance.date,
              AppConstant.TEACHER_DELETE_DAYS_LIMIT
            )
          ) {
            throw new HttpError(
              403,
              "Giáo viên chỉ được chỉnh sửa trong vòng 1 ngày kể từ ngày điểm danh"
            );
          }
        }
      }

      const record = await this.detailsRecordRepository.delete(recordId);

      await this.logger.log({
        userId: actorId,
        action: "DELETE_DETAIL_RECORD",
        roleSnapshot: userRole,
        targetId: recordId,
        metadata: { found: !!record },
      });
      return record;
    } catch (error) {
      await this.logger.log({
        userId: actorId,
        action: "DELETE_DETAIL_RECORD_FAILED",
        roleSnapshot: userRole,
        targetId: recordId,
        metadata: { error: (error as Error).message },
      });
      throw error;
    }
  }
}
export default DetailsRecordService;
