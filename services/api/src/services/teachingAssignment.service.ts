import TeachingAssignmentRepository from "../repositories/teachingAssignment.repository";
import ClassRepository from "../repositories/class.repository";
import TeacherRepository from "../repositories/teacher.repository";
import { DefaultLogger } from "../utils/DefaultLogger";
import { ITeachingAssignment } from "../models";

class TeachingAssignmentService {
  private readonly logger: DefaultLogger;
  private readonly teachingAssignmentRepository: TeachingAssignmentRepository;
  private readonly classRepository: ClassRepository;
  private readonly teacherRepository: TeacherRepository;
  constructor(
    logger: DefaultLogger,
    TeachingAssignmentModel: TeachingAssignmentRepository,
    ClassModel: ClassRepository,
    TeacherModel: TeacherRepository
  ) {
    this.logger = logger;
    this.teachingAssignmentRepository = TeachingAssignmentModel;
    this.classRepository = ClassModel;
    this.teacherRepository = TeacherModel;
  }
  async getAllTeachingAssignments(actorId: string, userRole: string) {
    try {
      const assignments = await this.teachingAssignmentRepository.findAll();
      if (!assignments || assignments.length === 0) {
        throw new Error("Không tìm thấy ban phân chia giảng dạy nào");
      }
      await this.logger.log({
        userId: actorId,
        action: "GET_ALL_TEACHING_ASSIGNMENTS",
        roleSnapshot: userRole,
        metadata: {
          assignmentsCount: assignments.length,
        },
      });
      return assignments;
    } catch (error) {
      await this.logger.log({
        userId: actorId,
        action: "GET_ALL_TEACHING_ASSIGNMENTS",
        roleSnapshot: userRole,
        metadata: { error: (error as Error).message },
      });
      throw error;
    }
  }
  async getTeachingAssignmentById(
    id: string,
    actorId: string,
    userRole: string
  ) {
    try {
      const assignments = await this.teachingAssignmentRepository.findById(id);

      if (!assignments) {
        throw new Error("Không tìm thấy lịch giảng dạy theo ID này");
      }
      await this.logger.log({
        userId: actorId,
        action: "GET_TEACHING_ASSIGNMENTS_BY_ID",
        roleSnapshot: userRole,
        targetId: id,
        metadata: { found: !!assignments },
      });
      return assignments;
    } catch (error) {
      await this.logger.log({
        userId: actorId,
        action: "GET_TEACHING_ASSIGNMENTS_BY_ID_FAILED",
        roleSnapshot: userRole,
        targetId: id,
        metadata: { error: (error as Error).message },
      });
      throw error;
    }
  }
  async createTeachingAssignment(
    assignmentData: Partial<ITeachingAssignment>,
    schoolId: string,
    actorId: string,
    userRole: string
  ) {
    try {
      const assignment = await this.teachingAssignmentRepository.create(
        assignmentData
      );
      const classId = await this.classRepository.findById(
        assignment.classId.toString()
      );
      if (!classId) {
        throw new Error("Không tìm thấy lớp học theo ID này");
      }

      if (schoolId !== classId.schoolId.toString()) {
        throw new Error("Bạn không có quyền truy cập vào lớp học này");
      }

      await this.logger.log({
        userId: actorId,
        action: "CREATE_TEACHING_ASSIGNMENTS",
        roleSnapshot: userRole,
        metadata: { found: !!assignment },
      });
      return assignment;
    } catch (error) {
      await this.logger.log({
        userId: actorId,
        action: "CREATE_TEACHING_ASSIGNMENTS_FAILED",
        roleSnapshot: userRole,
        metadata: { error: (error as Error).message },
      });
      throw error;
    }
  }

  async updateTeachingAssignment(
    id: string,
    assignmentData: Partial<ITeachingAssignment>,
    schoolId: string,
    actorId: string,
    userRole: string
  ) {
    try {
      if (!assignmentData || Object.keys(assignmentData).length === 0) {
        throw new Error("Dữ liệu bảng phân chia giảng dạy không được để trống");
      }
      if (userRole !== "SuperAdmin") {
        const existingAssignment =
          await this.teachingAssignmentRepository.findById(id);

        if (!existingAssignment) {
          throw new Error("Không tìm thấy bảng phân chia giảng dạy theo ID ");
        }

        //lấy ra teacherId từ class
        const assignmentTeacherId = existingAssignment.teacherId?.toString();

        //So sánh teacherId từ class
        if (assignmentTeacherId !== actorId) {
          throw new Error(
            "Bạn không có quyền chỉnh sửa bảng phân chia giảng dạy này"
          );
        }
      }

      const assignment = await this.teachingAssignmentRepository.update(
        id,
        assignmentData
      );

      await this.logger.log({
        userId: actorId,
        action: "UPDATE_TEACHING_ASSIGNMENTS",
        roleSnapshot: userRole,
        targetId: id,
        metadata: { found: !!assignment },
      });

      return assignment;
    } catch (error) {
      await this.logger.log({
        userId: actorId,
        action: "UPDATE_TEACHING_ASSIGNMENTS_FAILED",
        roleSnapshot: userRole,
        targetId: id,
        metadata: { error: (error as Error).message },
      });
      throw error;
    }
  }

  async deleteTeachingAssignment(
    id: string,
    schoolId: string,
    actorId: string,
    userRole: string
  ) {
    try {
      if (userRole !== "SuperAdmin") {
        const existingAssignment =
          await this.teachingAssignmentRepository.findById(id);

        if (!existingAssignment) {
          throw new Error("Không tìm thấy bảng phân chia giảng dạy theo ID ");
        }

        //lấy ra teacherId từ class
        const assignmentTeacherId = existingAssignment.teacherId?.toString();

        //So sánh teacherId từ class
        if (assignmentTeacherId !== actorId) {
          throw new Error(
            "Bạn không có quyền xóa bảng phân chia giảng dạy này"
          );
        }
      }

      const assignment = await this.teachingAssignmentRepository.delete(id);

      await this.logger.log({
        userId: actorId,
        action: "DELETE_TEACHING_ASSIGNMENTS",
        roleSnapshot: userRole,
        targetId: id,
        metadata: { found: !!assignment },
      });

      return assignment;
    } catch (error) {
      await this.logger.log({
        userId: actorId,
        action: "DELETE_TEACHING_ASSIGNMENTS_FAILED",
        roleSnapshot: userRole,
        targetId: id,
        metadata: { error: (error as Error).message },
      });
      throw error;
    }
  }
}

export default TeachingAssignmentService;
