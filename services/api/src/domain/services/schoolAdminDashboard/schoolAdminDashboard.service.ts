import { ClassAttendanceStats } from "../../../common/interfaces/classAttendanceStats.interface";
import { DefaultLogger } from "../../../common/utils/DefaultLogger";
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
  ): Promise<ClassAttendanceStats[]> {
    try {
      // lấy thống kê từng lớp
      const classStats =
        await this.attendanceStatsRepository.getAttendanceStatsBySchool(
          schoolId,
          date
        );

      console.log(classStats);
      await this.logger.log({
        userId: actorId,
        action: "GET_SCHOOL_ATTENDANCE_STATS",
        roleSnapshot: userRole,
        metadata: {
          classStats,
        },
      });

      return classStats;
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
