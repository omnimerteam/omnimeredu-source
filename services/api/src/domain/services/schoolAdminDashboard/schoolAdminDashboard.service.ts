import { DefaultLogger } from "../../../common/utils/DefaultLogger";
import { AttendanceStatsEntity } from "../../entities/attendanceStats.entity";
import {
  AttendanceStatsRepository,
  SchoolAdminDashboardRepository,
} from "../../repositories";

class SchoolAdminDashboardService {
  private readonly attendanceStatsRepository: AttendanceStatsRepository;
  private readonly schoolAdminDashboardRepository: SchoolAdminDashboardRepository;
  private readonly logger: DefaultLogger;

  constructor(
    attendanceStatsRepository: AttendanceStatsRepository,
    schoolAdminDashboardRepository: SchoolAdminDashboardRepository,
    logger: DefaultLogger
  ) {
    this.attendanceStatsRepository = attendanceStatsRepository;
    this.schoolAdminDashboardRepository = schoolAdminDashboardRepository;
    this.logger = logger;
  }

  /**
   * Lấy thống kê điểm danh của trường trong ngày
   * @param schoolId id của trường
   * @param date (optional) ngày cần thống kê, default = hôm nay
   */
  async getSchoolAttendanceStats(
    actorId: string,
    userRole: string,
    schoolId: string,
    date?: Date
  ): Promise<AttendanceStatsEntity> {
    try {
      // lấy thống kê từng lớp
      const classStats =
        await this.attendanceStatsRepository.getAttendanceStatsBySchool(
          schoolId,
          date
        );

      // convert sang map: { className: attendanceRate }
      const classAttendanceRates: Record<string, number> = {};
      let totalPresent = 0;
      let totalStudents = 0;

      classStats.forEach((cls: any) => {
        classAttendanceRates[cls.className] = cls.classAttendanceRate;
        totalPresent += cls.classAttendanceRate * (cls.total ?? 0);
        totalStudents += cls.total ?? 0;
      });

      // tỷ lệ toàn trường
      const schoolAttendanceRate =
        totalStudents > 0 ? totalPresent / totalStudents : 0;

      await this.logger.log({
        userId: actorId,
        action: "GET_SCHOOL_ATTENDANCE_STATS",
        roleSnapshot: userRole,
        metadata: {
          attendanceRate: schoolAttendanceRate,
          classAttendanceRates,
          date: date ?? new Date(),
        },
      });

      return new AttendanceStatsEntity({
        attendanceRate: schoolAttendanceRate,
        classAttendanceRates,
        date: date ?? new Date(),
      });
    } catch (error) {
      await this.logger.log({
        userId: actorId,
        action: "GET_SCHOOL_ATTENDANCE_STATS_FAILED",
        roleSnapshot: userRole,
        metadata: { error: (error as Error).message },
      });
      throw error;
    }
  }

  async getSummary(actorId: string, userRole: string, schoolId: string) {
    try {
      const result = await this.schoolAdminDashboardRepository.getSummary(
        schoolId
      );
      await this.logger.log({
        userId: actorId,
        action: "GET_SUMMARY",
        roleSnapshot: userRole,
        metadata: {
          result,
        },
      });
      return result;
    } catch (error) {
      await this.logger.log({
        userId: actorId,
        action: "GET_SUMMARY_FAILED",
        roleSnapshot: userRole,
        metadata: { error: (error as Error).message },
      });
      throw error;
    }
  }
}

export default SchoolAdminDashboardService;
