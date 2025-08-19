import DetailsRecordRepository from "../repositories/detailsRecord.repository.js";
import AttendanceRepository from "../repositories/attendance.repository.js";
import { IDetailsRecord } from "../models/school/attendance/DetailsRecord.js";
import { DefaultLogger } from "../utils/DefaultLogger.js";
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
      if (!existingRecord) {
        throw new Error("Không tìm thấy bản ghi theo ID");
      }

      const attendanceID = existingRecord?.attendanceId?.toString();
      const existingAttendance = await this.attendanceRepository.findById(
        attendanceID
      );
      if (!existingAttendance) {
        throw new Error("Không tìm thấy buổi điểm danh liên quan");
      }

      const existingAttendanceSchoolId =
        existingAttendance?.schoolId?.toString();

      // SuperAdmin => toàn quyền, bỏ qua các check
      if (userRole !== "SuperAdmin") {
        // SchoolAdmin chỉ được chỉnh trong trường của mình
        if (
          userRole === "SchoolAdmin" &&
          schoolId !== existingAttendanceSchoolId
        ) {
          throw new Error(
            "Bạn không có quyền truy cập để chỉnh sửa bản ghi này"
          );
        }

        // Teacher => phải cùng trường và trong 2 ngày
        if (userRole === "Teacher") {
          if (schoolId !== existingAttendanceSchoolId) {
            throw new Error(
              "Bạn không có quyền truy cập để chỉnh sửa bản ghi này"
            );
          }
          const attendanceDate = new Date(existingAttendance.date);
          const now = new Date();
          const diffInDays =
            (now.getTime() - attendanceDate.getTime()) / (1000 * 60 * 60 * 24);
          if (diffInDays > 2) {
            throw new Error(
              "Teacher chỉ được thay đổi bản ghi trong vòng 2 ngày kể từ ngày điểm danh"
            );
          }
        }
      }

      const record = await this.detailsRecordRepository.update(
        recordId,
        recordData
      );

      await this.logger.log({
        userId: actorId,
        action: "UPDATE_DETAIL_RECORD",
        roleSnapshot: userRole,
        targetId: recordId,
        metadata: { found: !!record },
      });

      return record;
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
      if (!existingRecord) {
        throw new Error("Không tìm thấy bản ghi theo ID");
      }

      const attendanceID = existingRecord?.attendanceId?.toString();
      const existingAttendance = await this.attendanceRepository.findById(
        attendanceID
      );

      if (!existingAttendance) {
        throw new Error("Không tìm thấy buổi điểm danh liên quan");
      }

      const existingAttendanceSchoolId =
        existingAttendance?.schoolId?.toString();

      if (userRole !== "SuperAdmin") {
        if (
          userRole === "SchoolAdmin" &&
          schoolId !== existingAttendanceSchoolId
        ) {
          throw new Error("Bạn không có quyền truy cập để xóa bản ghi này");
        }

        if (userRole === "Teacher") {
          const attendanceDate = new Date(existingAttendance.date);
          const now = new Date();
          const compare = now.getTime() - attendanceDate.getTime();
          const current = compare / (1000 * 60 * 60 * 24);
          if (current > 1) {
            throw new Error(
              "Teacher chỉ được xóa bản ghi trong vòng 1 ngày kể từ ngày điểm danh"
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
