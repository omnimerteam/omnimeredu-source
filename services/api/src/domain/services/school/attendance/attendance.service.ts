import DateUtils from "../../../../common/utils/DateUtils";
import { DefaultLogger } from "../../../../common/utils/DefaultLogger";
import { HttpError } from "../../../../common/utils/HttpError";
import { buildPermissionFilterForClass } from "../../../../common/utils/permissionFilter";
import { IAttendance } from "../../../models";
import {
  AttendanceRepository,
  ClassRepository,
  AttendanceRecordViewRepository,
} from "../../../repositories";
import { PaginationQueryOptions } from "../../../../common/utils/buildQueryOptions";
import { determineSessionType } from "../../../utils/determineSessionType";
import { translateStatus } from "../../../utils/ExcelUtils";
import ExcelJS from "exceljs";
import { AttendanceExcelBuilder } from "./attendance.excel-builder";

class AttendanceService {
  private readonly attendanceRepository: AttendanceRepository;
  private readonly classRepository: ClassRepository;
  private readonly logger: DefaultLogger;
  private readonly attendanceRecordViewRepository: AttendanceRecordViewRepository;

  constructor(
    attendanceRepository: AttendanceRepository,
    classRepository: ClassRepository,
    attendanceRecordViewRepository: AttendanceRecordViewRepository,
    logger: DefaultLogger
  ) {
    this.attendanceRepository = attendanceRepository;
    this.classRepository = classRepository;
    this.attendanceRecordViewRepository = attendanceRecordViewRepository;
    this.logger = logger;
  }

  async getAllAttendances(
    actorId: string,
    userRole: string,
    schoolId?: string,
    options?: PaginationQueryOptions
  ) {
    try {
      let filter: any = {};

      filter = buildPermissionFilterForClass(userRole, schoolId);

      const attendances = await this.attendanceRepository.findAllAttendances(
        filter,
        options
      );

      await this.logger.log({
        userId: actorId,
        action: "GET_ALL_ATTENDANCES",
        roleSnapshot: userRole,
        metadata: { count: attendances.length },
      });
      return attendances;
    } catch (error) {
      await this.logger.log({
        userId: actorId,
        action: "GET_ALL_ATTENDANCES_FAILED",
        roleSnapshot: userRole,
        metadata: { error: (error as Error).message },
      });
      throw error;
    }
  }

  async getAttendanceById(
    id: string,
    actorSchoolId: string,
    actorId: string,
    userRole: string
  ) {
    try {
      const attendance = await this.attendanceRepository.findById(id);
      if (!attendance) {
        throw new HttpError(404, "Không tìm thấy buổi điểm danh");
      }

      // Chỉ kiểm tra khi không phải SuperAdmin
      if (
        userRole === "SchoolAdmin" &&
        actorSchoolId != attendance.schoolId?.toString()
      ) {
        throw new HttpError(403, "Tài khoản không có quyền truy cập");
      }

      await this.logger.log({
        userId: actorId,
        action: "GET_ATTENDANCE_BY_ID",
        roleSnapshot: userRole,
        targetId: id,
        metadata: { attendance },
      });

      return attendance;
    } catch (error) {
      await this.logger.log({
        userId: actorId,
        action: "GET_ATTENDANCE_BY_ID_FAILED",
        roleSnapshot: userRole,
        targetId: id,
        metadata: { error: (error as Error).message },
      });
      throw error;
    }
  }

  async getAttendanceRecordViewById(
    id: string,
    actorSchoolId: string,
    actorId: string,
    userRole: string
  ) {
    try {
      const attendance = await this.attendanceRecordViewRepository.findById(id);
      if (!attendance) {
        throw new HttpError(404, "Không tìm thấy bảng điểm danh");
      }

      // Chỉ kiểm tra khi không phải SuperAdmin
      if (
        userRole === "SchoolAdmin" &&
        actorSchoolId != attendance.schoolId?.toString()
      ) {
        throw new HttpError(403, "Tài khoản không có quyền truy cập");
      }

      await this.logger.log({
        userId: actorId,
        action: "GET_ATTENDANCE_RECORD_VIEW_BY_ID",
        roleSnapshot: userRole,
        targetId: id,
        metadata: { attendance },
      });

      return attendance;
    } catch (error) {
      await this.logger.log({
        userId: actorId,
        action: "GET_ATTENDANCE_RECORD_VIEW_BY_ID_FAILED",
        roleSnapshot: userRole,
        targetId: id,
        metadata: { error: (error as Error).message },
      });
      throw error;
    }
  }

  async getClassAttendanceRecordView(
    classId: string,
    actorId: string,
    actorSchoolId: string,
    userRole: string,
    date: Date,
    timezone: string = "Asia/Ho_Chi_Minh" // default múi giờ VN
  ) {
    try {
      if (userRole !== "SuperAdmin") {
        const currentClass = await this.classRepository.findById(classId);
        if (!currentClass) {
          throw new HttpError(
            400,
            "Không tìm thấy thông tin của lớp điểm danh"
          );
        }

        if (actorSchoolId != currentClass.schoolId.toString()) {
          throw new HttpError(
            403,
            "Bạn không có quyền xem bảng điểm danh của lớp này"
          );
        }
      }

      // 🔹 Convert date sang start/end UTC theo timezone
      let filter: any = { classId };
      const { start, end } = DateUtils.getUtcDayRange(date, timezone);
      filter.date = { $gte: start, $lte: end };

      console.log("Filter for getAttendancesByClassId:", filter);

      const attendance = await this.attendanceRecordViewRepository.findOne(
        filter
      );

      await this.logger.log({
        userId: actorId,
        action: "GET_ATTENDANCE_RECORD_VIEW",
        roleSnapshot: userRole,
        targetId: classId,
        metadata: { attendance },
      });

      return attendance;
    } catch (error) {
      await this.logger.log({
        userId: actorId,
        action: "GET_ATTENDANCE_RECORD_VIEW_FAILED",
        roleSnapshot: userRole,
        targetId: classId,
        metadata: { error: (error as Error).message },
      });
      throw error;
    }
  }

  async createAttendance(
    AttendanceData: Partial<IAttendance>,
    actorSchoolId: string,
    actorId: string,
    userRole: string
  ) {
    try {
      if (userRole !== "SuperAdmin") {
        // Tìm class và populate schoolId (nếu cần)
        const currentClass = await this.classRepository.findById(
          AttendanceData.classId!.toString()
        );

        if (!currentClass) {
          throw new HttpError(
            400,
            "Không tìm thấy thông tin của lớp điểm danh"
          );
        }

        if (actorSchoolId != currentClass.schoolId.toString()) {
          throw new HttpError(
            403,
            "Bạn không có quyền tạo bảng điểm danh cho trường"
          );
        }
      }

      if (AttendanceData.date) {
        AttendanceData.sessionType = await determineSessionType(
          AttendanceData.date,
          actorSchoolId
        );
      } else {
        throw new HttpError(400, "Thiếu ngày để lập bảng điểm danh");
      }

      const attendance = await this.attendanceRepository.create(AttendanceData);

      await this.logger.log({
        userId: actorId,
        action: "CREATE_ATTENDANCE",
        roleSnapshot: userRole,
        metadata: { attendance },
      });

      return attendance;
    } catch (error) {
      await this.logger.log({
        userId: actorId,
        action: "CREATE_ATTENDANCE_FAILED",
        roleSnapshot: userRole,
        metadata: { error: (error as Error).message },
      });
      throw error;
    }
  }

  async initializeClassAttendance(
    AttendanceData: Partial<IAttendance>,
    actorSchoolId: string,
    actorId: string,
    userRole: string
  ) {
    try {
      if (userRole !== "SuperAdmin") {
        // Tìm class và populate schoolId (nếu cần)
        const currentClass = await this.classRepository.findById(
          AttendanceData.classId!.toString()
        );

        if (!currentClass) {
          throw new HttpError(
            400,
            "Không tìm thấy thông tin của lớp điểm danh"
          );
        }

        if (actorSchoolId != currentClass.schoolId.toString()) {
          throw new HttpError(
            403,
            "Bạn không có quyền tạo bảng điểm danh cho trường"
          );
        }
      }

      if (AttendanceData.date) {
        AttendanceData.sessionType = await determineSessionType(
          AttendanceData.date,
          actorSchoolId
        );
      } else {
        throw new HttpError(400, "Thiếu ngày để tạo mới");
      }

      const attendance =
        await this.attendanceRepository.getOrInitializeTodayAttendance(
          AttendanceData
        );

      await this.logger.log({
        userId: actorId,
        action: "INITIALIZE_CLASS_ATTENDANCE",
        roleSnapshot: userRole,
        metadata: { attendance },
      });

      return attendance;
    } catch (error) {
      await this.logger.log({
        userId: actorId,
        action: "INITIALIZE_CLASS_ATTENDANCE_FAILED",
        roleSnapshot: userRole,
        metadata: { error: (error as Error).message },
      });
      throw error;
    }
  }

  async updateAttendance(
    attendanceId: string,
    AttendanceData: Partial<IAttendance>,
    actorId: string,
    actorSchoolId: string,
    userRole: string
  ) {
    try {
      if (userRole !== "SuperAdmin") {
        const currentAttendance = await this.attendanceRepository.findById(
          attendanceId.toString()
        );

        //Kiem tra biến currentClass có tồn tại hay không
        if (!currentAttendance) {
          throw new Error("Không tìm thấy thông tin của lớp điểm danh");
        }

        //schoolId from currentClass
        const attendanceSchoolId = currentAttendance?.schoolId.toString();

        // So sánh schoolId
        if (
          userRole === "SchoolAdmin" &&
          actorSchoolId !== attendanceSchoolId
        ) {
          throw new Error(
            "Bạn không có quyền cập nhật bảng điểm danh cho trường này"
          );
        }

        if (userRole === "Teacher") {
          if (actorSchoolId !== attendanceSchoolId) {
            throw new Error(
              "Bạn không có quyền truy cập để chỉnh sửa bản ghi này"
            );
          }
          const attendanceDate = new Date(currentAttendance.date);
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

      if (AttendanceData.date) {
        AttendanceData.sessionType = await determineSessionType(
          AttendanceData.date,
          actorSchoolId
        );
      }

      const attendance = await this.attendanceRepository.update(
        attendanceId,
        AttendanceData
      );

      await this.logger.log({
        userId: actorId,
        action: "UPDATE_ATTENDANCE",
        roleSnapshot: userRole,
        targetId: attendanceId,
        metadata: { attendance: attendance },
      });
      return attendance;
    } catch (error) {
      await this.logger.log({
        userId: actorId,
        action: "UPDATE_ATTENDANCE_FAILED",
        roleSnapshot: userRole,
        targetId: attendanceId,
        metadata: { error: (error as Error).message },
      });
      throw error;
    }
  }

  async deleteAttendance(
    attendanceId: string,
    actorId: string,
    actorSchoolId: string,
    userRole: string
  ) {
    try {
      if (userRole !== "SuperAdmin") {
        const currentAttendance = await this.attendanceRepository.findById(
          attendanceId.toString()
        );

        //Kiem tra currentAttendance có tồn tại hay không
        if (!currentAttendance) {
          throw new HttpError(
            403,
            "Không tìm thấy thông tin của lớp điểm danh"
          );
        }

        //schoolId from currentClass
        const attendanceSchoolId = currentAttendance?.schoolId.toString();

        // So sánh schoolId
        if (actorSchoolId !== attendanceSchoolId) {
          throw new Error(
            "Bạn không có quyền xóa bảng điểm danh cho trường này"
          );
        }
      }

      const attendance = await this.attendanceRepository.delete(attendanceId);

      await this.logger.log({
        userId: actorId,
        action: "DELETE_ATTENDANCE",
        roleSnapshot: userRole,
        targetId: attendanceId,
        metadata: { attendance: attendance },
      });
      return attendance;
    } catch (error) {
      await this.logger.log({
        userId: actorId,
        action: "DELETE_ATTENDANCE_FAILED",
        roleSnapshot: userRole,
        targetId: attendanceId,
        metadata: { error: (error as Error).message },
      });
      throw error;
    }
  }

  /**
   * Xuất file Excel điểm danh theo ID
   * @param {string} attendanceId
   * @returns {Buffer} Excel file buffer
   */
  async generateQRCode(
    attendanceId: string,
    actorSchoolId: string,
    actorId: string,
    userRole: string
  ) {
    try {
      // Verify attendance exists and user has permission
      const attendance = await this.getAttendanceById(
        attendanceId,
        actorSchoolId,
        actorId,
        userRole
      );

      if (!attendance) {
        throw new HttpError(404, "Attendance not found");
      }

      // Generate dynamic code (6 digits)
      const dynamicCode = Math.floor(100000 + Math.random() * 900000).toString();

      // Create QR data payload
      const payload = {
        attendanceId: attendance._id?.toString(),
        timestamp: new Date().toISOString(),
        dynamicCode: dynamicCode,
      };

      // Encode QR data (base64)
      const qrData = Buffer.from(JSON.stringify(payload)).toString("base64");

      // Set expiry time (3 minutes from now)
      // Có thể thay đổi số phút ở đây (ví dụ: 2, 3, 5, 10 phút)
      const QR_EXPIRY_MINUTES = 1;
      const expiry = new Date();
      expiry.setMinutes(expiry.getMinutes() + QR_EXPIRY_MINUTES);

      await this.logger.log({
        userId: actorId,
        action: "GENERATE_QR_CODE",
        roleSnapshot: userRole,
        targetId: attendanceId,
        metadata: { attendanceId },
      });

      return {
        attendanceId: attendance._id?.toString() || attendanceId,
        qrData: qrData,
        expiry: expiry.toISOString(),
        dynamicCode: dynamicCode,
      };
    } catch (error) {
      await this.logger.log({
        userId: actorId,
        action: "GENERATE_QR_CODE_FAILED",
        roleSnapshot: userRole,
        targetId: attendanceId,
        metadata: { error: (error as Error).message },
      });
      throw error;
    }
  }

  async exportAttendanceExcel(actorId: string, attendanceId: string) {
    try {
      const attendance = await this.attendanceRecordViewRepository.findById(
        attendanceId
      );
      if (!attendance)
        throw new HttpError(403, "Không tìm thấy bản ghi điểm danh");

      const builder = new AttendanceExcelBuilder();
      const buffer = await builder.build(attendance);

      await this.logger.log({
        userId: actorId,
        action: "EXPORT_ATTENDANCE_EXCEL",
        targetId: attendanceId,
      });

      return buffer;
    } catch (error: any) {
      await this.logger.log({
        userId: actorId,
        action: "EXPORT_ATTENDANCE_EXCEL_FAILED",
        targetId: attendanceId,
        metadata: { error: error.message },
      });
      throw error;
    }
  }
}
export default AttendanceService;
