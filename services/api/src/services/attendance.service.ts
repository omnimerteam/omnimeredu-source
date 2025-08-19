import { DefaultLogger } from "../utils/DefaultLogger";
import { IAttendance } from "../models";
import AttendanceRepository from "../repositories/attendance.repository";
import SchoolAdmin from "../repositories/schoolAdmin.repository";
import ClassRepository from "../repositories/class.repository";
import TeacherRepository from "../repositories/teacher.repository";

class AttendanceService {
  private readonly attendanceRepository: AttendanceRepository;
  private readonly schoolAdminRepository: SchoolAdmin;
  private readonly classRepository: ClassRepository;
  private readonly teacherRepository: TeacherRepository;
  private readonly logger: DefaultLogger;

  constructor(
    attendanceRepository: AttendanceRepository,
    schoolAdminRepository: SchoolAdmin,
    classRepository: ClassRepository,
    teacherRepository: TeacherRepository,
    logger: DefaultLogger
  ) {
    this.attendanceRepository = attendanceRepository;
    this.schoolAdminRepository = schoolAdminRepository;
    this.classRepository = classRepository;
    this.teacherRepository = teacherRepository;
    this.logger = logger;
  }

  async getAllAttendances(actorId: string, userRole: string) {
    try {
      const attendances = await this.attendanceRepository.findAll();
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
        throw new Error("Không tìm thấy buổi điểm danh");
      }

      const attendanceSchoolId = attendance.schoolId?.toString();

      // Chỉ kiểm tra khi không phải SuperAdmin
      if (userRole === "SchoolAdmin" && actorSchoolId !== attendanceSchoolId) {
        throw new Error("Tài khoản không có quyền truy cập");
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

  async getAttendancesBySchoolId(
    schoolId: string,
    actorSchoolId: string,
    actorId: string,
    userRole: string
  ) {
    try {
      if (userRole === "SchoolAdmin" && actorSchoolId !== schoolId) {
        throw new Error("Tài khoản không có quyền truy cập");
      }

      const attendances = await this.attendanceRepository.findBySchoolId(
        schoolId
      );

      await this.logger.log({
        userId: actorId,
        action: "GET_ATTENDANCES_BY_SCHOOL_ID",
        roleSnapshot: userRole,
        targetId: schoolId,
        metadata: { count: attendances.length },
      });

      return attendances;
    } catch (error) {
      await this.logger.log({
        userId: actorId,
        action: "GET_ATTENDACENCES_BY_SCHOOL_ID_FAILED",
        roleSnapshot: userRole,
        targetId: schoolId,
        metadata: { error: (error as Error).message },
      });
      throw error;
    }
  }

  async getAttendancesByClassId(
    classId: string,
    actorId: string,
    actorSchoolId: string,
    userRole: string
  ) {
    try {
      if (userRole !== "SuperAdmin") {
        const currentClass = await this.classRepository.findById(
          classId.toString()
        );

        //Kiem tra currentClass có tồn tại hay không
        if (!currentClass) {
          throw new Error("class not found");
        }

        //schoolId from currentClass
        const classSchoolId = currentClass?.schoolId.toString();

        // So sánh schoolId
        if (userRole === "SchoolAdmin" && actorSchoolId !== classSchoolId) {
          throw new Error(
            "Bạn không có quyền truy cập bảng điểm danh của lớp này"
          );
        }
      }

      const attendances = await this.attendanceRepository.findByClassId(
        classId
      );

      await this.logger.log({
        userId: actorId,
        action: "GET_ATTENDANCE_BY_CLASS_ID",
        roleSnapshot: userRole,
        targetId: classId,
        metadata: { count: attendances.length },
      });
      return attendances;
    } catch (error) {
      await this.logger.log({
        userId: actorId,
        action: "GET_ATTENDANCE_BY_CLASS_ID_FAILED",
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
        const classId = AttendanceData.classId;
        if (!classId) {
          throw new Error("ID của lớp điểm danh không được cung cấp");
        }

        // Tìm class và populate schoolId (nếu cần)
        const currentClass = await this.classRepository.findById(
          classId.toString()
        );

        if (!currentClass) {
          throw new Error("Không tìm thấy thông tin của lớp điểm danh");
        }

        const classSchoolId = currentClass.schoolId?.toString();

        if (userRole === "SchoolAdmin" && actorSchoolId !== classSchoolId) {
          throw new Error("Bạn không có quyền tạo bảng điểm danh cho trường");
        }
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
}
export default AttendanceService;
