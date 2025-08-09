import { DefaultLogger } from '../utils/DefaultLogger';
import { IAttendance } from '../models/Attendance';
import { NormalizeObjectId } from '../utils/NormalizeObjectId';
import AttendanceRepository from '../repositories/attendance.repository';
import SchoolAdmin from '../repositories/schoolAdmin.repository';
import ClassRepository from '../repositories/class.repository';
import TeacherRepository from '../repositories/teacher.repository';

class AttendanceService {
    private readonly attendanceRepository: AttendanceRepository;
    private readonly schoolAdminRepository: SchoolAdmin;
    private readonly classRepository: ClassRepository;
    private readonly teacherRepository: TeacherRepository;
    private readonly logger: DefaultLogger;

    constructor(attendanceRepository: AttendanceRepository, schoolAdminRepository: SchoolAdmin, classRepository: ClassRepository, teacherRepository: TeacherRepository, logger: DefaultLogger) {
        this.attendanceRepository = attendanceRepository;
        this.schoolAdminRepository = schoolAdminRepository;
        this.classRepository = classRepository;
        this.teacherRepository = teacherRepository;
        this.logger = logger;
    }

    async getAllAttendances(userId: string, userRole: string) {
        try {
            const attendances = await this.attendanceRepository.findAll();
            await this.logger.log({
                userId,
                action: "GET_ALL_ATTENDANCES",
                roleSnapshot: userRole,
                metadata: { count: attendances.length }
            })
            return attendances;
        } catch (error) {
            await this.logger.log({
                userId,
                action: "GET_ALL_ATTENDANCES_FAILED",
                roleSnapshot: userRole,
                metadata: { error: (error as Error).message }
            })
            throw error;
        }
    }

    async getAttendanceById(id: string, userId: string, userRole: string) {
        try {
            const attendance = await this.attendanceRepository.findById(id);
            await this.logger.log({
                userId,
                action: "GET_ATTENDANCE_BY_ID",
                roleSnapshot: userRole,
                targetId: id,
                metadata: { attendance: attendance }
            })
            return attendance;
        } catch (error) {
            await this.logger.log({
                userId,
                action: "GET_ATTENDANCE_BY_ID_FAILED",
                roleSnapshot: userRole,
                targetId: id,
                metadata: { error: (error as Error).message }
            })
            throw error;
        }
    }

    async getAttendancesBySchoolId(schoolId: string, userId: string, userRole: string) {
        try {
            // Tìm user theo userId (SchoolAdmin)
            const userAdmin = await this.schoolAdminRepository.findByUserId(userId.toString());

            if (!userAdmin) {
                throw new Error("User not found");
            }

            // So sánh schoolId sau khi normalize
            const userSchoolId = NormalizeObjectId(userAdmin.schoolId);

            if (userSchoolId !== schoolId) {
                throw new Error("You do not have permission to get all attendances of this school");
            }

            const attendances = await this.attendanceRepository.findBySchoolId(schoolId);

            await this.logger.log({
                userId,
                action: "GET_ATTENDANCES_BY_SCHOOL_ID",
                roleSnapshot: userRole,
                targetId: schoolId,
                metadata: { count: attendances.length }
            })

            return attendances;
        } catch (error) {
            await this.logger.log({
                userId,
                action: "GET_ATTENDACENCES_BY_SCHOOL_ID_FAILED",
                roleSnapshot: userRole,
                targetId: schoolId,
                metadata: { error: (error as Error).message }
            })
            throw error;
        }
    }

    async getAttendancesByClassId(classId: string, userId: string, userRole: string) {
        try {
            // Tìm user theo userId (SchoolAdmin)
            const userAdmin = await this.schoolAdminRepository.findByUserId(userId.toString());
            const currentClass = await this.classRepository.findById(classId.toString());

            //Kiem tra 2 biến userAdmin và currentClass có tồn tại hay không
            if (!userAdmin || !currentClass) {
                throw new Error("User or class not found");
            }

            // Normalize schoolId from userAdmin and currentClass
            const userSchoolId = NormalizeObjectId(userAdmin.schoolId);
            const classSchoolId = NormalizeObjectId(currentClass.schoolId);
            console.log("userSchoolId", userSchoolId, "classSchoolId", classSchoolId);
            console.log("User Role", userRole);

            // So sánh schoolId sau khi normalize
            if (userSchoolId !== classSchoolId) {
                throw new Error("You do not have permission to get attendances for this class");
            }

            const attendances = await this.attendanceRepository.findByClassId(classId);

            await this.logger.log({
                userId,
                action: "GET_ATTENDANCE_BY_CLASS_ID",
                roleSnapshot: userRole,
                targetId: classId,
                metadata: { count: attendances.length }
            });

            return attendances;
        } catch (error) {
            await this.logger.log({
                userId,
                action: "GET_ATTENDANCE_BY_CLASS_ID_FAILED",
                roleSnapshot: userRole,
                targetId: classId,
                metadata: { error: (error as Error).message }
            })
            throw error;
        }
    }

    async createAttendance(AttendanceData: Partial<IAttendance>, userId: string, userRole: string) {
        try {
            const classId = AttendanceData.classId;
            if (!classId) {
                throw new Error("Class ID is required");
            }

            // Tìm user theo userId (SchoolAdmin)
            const userAdmin = await this.schoolAdminRepository.findByUserId(userId.toString());

            if (!userAdmin) {
                throw new Error("User not found");
            }

            // Tìm class và populate schoolId (nếu cần)
            const currentClass = await this.classRepository.findById(classId.toString());
            if (!currentClass) {
                throw new Error("Class not found");
            }

            // So sánh schoolId sau khi normalize
            const userSchoolId = NormalizeObjectId(userAdmin.schoolId);
            const classSchoolId = NormalizeObjectId(currentClass.schoolId);

            if (userSchoolId !== classSchoolId) {
                throw new Error("You do not have permission to create attendance for this class");
            }

            const attendance = await this.attendanceRepository.create(AttendanceData);

            await this.logger.log({
                userId,
                action: "CREATE_ATTENDANCE",
                roleSnapshot: userRole,
                metadata: { attendance }
            });

            return attendance;
        } catch (error) {
            await this.logger.log({
                userId,
                action: "CREATE_ATTENDANCE_FAILED",
                roleSnapshot: userRole,
                metadata: { error: (error as Error).message }
            });
            throw error;
        }
    }

    async updateAttendance(attendanceId: string, AttendanceData: Partial<IAttendance>, userId: string, userRole: string) {
        try {
            // Tìm user theo userId (SchoolAdmin)
            const userAdmin = await this.schoolAdminRepository.findByUserId(userId.toString());
            const currentAttendance = await this.attendanceRepository.findById(attendanceId.toString());

            //Kiem tra 2 biến userAdmin và currentClass có tồn tại hay không
            if (!userAdmin || !currentAttendance) {
                throw new Error("User or class not found");
            }

            // Normalize schoolId from userAdmin and currentClass
            const userSchoolId = NormalizeObjectId(userAdmin.schoolId);
            const attendanceSchoolId = NormalizeObjectId(currentAttendance.schoolId);

            // So sánh schoolId sau khi normalize
            if (userSchoolId !== attendanceSchoolId) {
                throw new Error("You do not have permission to update attendance for this school");
            }

            const attendance = await this.attendanceRepository.update(attendanceId, AttendanceData);
            await this.logger.log({
                userId,
                action: "UPDATE_ATTENDANCE",
                roleSnapshot: userRole,
                targetId: attendanceId,
                metadata: { attendance: attendance }
            })
            return attendance;
        } catch (error) {
            await this.logger.log({
                userId,
                action: "UPDATE_ATTENDANCE_FAILED",
                roleSnapshot: userRole,
                targetId: attendanceId,
                metadata: { error: (error as Error).message }
            })
            throw error;
        }
    }

    async deleteAttendance(attendanceId: string, userId: string, userRole: string) {
        try {
            // Tìm user theo userId (SchoolAdmin)
            const userAdmin = await this.schoolAdminRepository.findByUserId(userId.toString());
            const currentAttendance = await this.attendanceRepository.findById(attendanceId.toString());

            //Kiem tra 2 biến userAdmin và currentClass có tồn tại hay không
            if (!userAdmin || !currentAttendance) {
                throw new Error("User or class not found");
            }

            // Normalize schoolId from userAdmin and currentClass
            const userSchoolId = NormalizeObjectId(userAdmin.schoolId);
            const attendanceSchoolId = NormalizeObjectId(currentAttendance.schoolId);

            // So sánh schoolId sau khi normalize
            if (userSchoolId !== attendanceSchoolId) {
                throw new Error("You do not have permission to delete attendance for this school");
            }

            const attendance = await this.attendanceRepository.delete(attendanceId);
            await this.logger.log({
                userId,
                action: "DELETE_ATTENDANCE",
                roleSnapshot: userRole,
                targetId: attendanceId,
                metadata: { attendance: attendance }
            })
            return attendance;
        } catch (error) {
            await this.logger.log({
                userId,
                action: "DELETE_ATTENDANCE_FAILED",
                roleSnapshot: userRole,
                targetId: attendanceId,
                metadata: { error: (error as Error).message }
            })
            throw error;
        }
    }
}
export default AttendanceService;