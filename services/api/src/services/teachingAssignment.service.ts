import TeachingAssignmentRepository from "../repositories/teachingAssignment.repository";
import ClassRepository from "../repositories/class.repository";
import TeacherRepository from "../repositories/teacher.repository";
import SchoolAdmin from "../repositories/schoolAdmin.repository";
import { findUserByUserId } from "../repositories/account.repository";
import { DefaultLogger } from "../utils/DefaultLogger";
import { ITeachingAssignment } from "../models/TeachingAssignment";

class TeachingAssignmentService {
  private readonly logger: DefaultLogger;
  private readonly teachingAssignmentRepository: TeachingAssignmentRepository;
  private readonly classRepository: ClassRepository;
  private readonly teacherRepository: TeacherRepository;
  private readonly schoolAdminRepository: SchoolAdmin;
  constructor(
    logger: DefaultLogger,
    TeachingAssignmentModel: TeachingAssignmentRepository,
    TeacherRepository: TeacherRepository,
    ClassModel: ClassRepository,
    SchoolAdmin: SchoolAdmin
  ) {
    this.logger = logger;
    this.teachingAssignmentRepository = TeachingAssignmentModel;
    this.teacherRepository = TeacherRepository;
    this.classRepository = ClassModel;
    this.schoolAdminRepository = SchoolAdmin;
  }
  async getAllTeachingAssignments(userId: string, userRole: string) {
    try {
      const assignments = await this.teachingAssignmentRepository.findAll();
      if (!assignments || assignments.length === 0) {
        throw new Error("No teaching assignments found");
      }
      await this.logger.log({
        userId,
        action: "GET_ALL_TEACHING_ASSIGNMENTS",
        roleSnapshot: userRole,
        metadata: {
          assignmentsCount: assignments.length,
        },
      });
      return assignments;
    } catch (error) {
      await this.logger.log({
        userId,
        action: "GET_ALL_TEACHING_ASSIGNMENTS",
        roleSnapshot: userRole,
        metadata: { error: (error as Error).message },
      });
      throw error;
    }
  }
  async getTeachingAssignmentById(
    id: string,
    userId: string,
    userRole: string
  ) {
    try {
      const assignments = await this.teachingAssignmentRepository.findById(id);

      if (!assignments) {
        throw new Error("No teaching assignments found");
      }
      await this.logger.log({
        userId,
        action: "GET_TEACHING_ASSIGNMENTS_BY_TEACHER_ID",
        roleSnapshot: userRole,
        targetId: id,
        metadata: { found: !!assignments },
      });
      return assignments;
    } catch (error) {
      await this.logger.log({
        userId,
        action: "GET_TEACHING_ASSIGNMENTS_BY_TEACHER_ID_FAILED",
        roleSnapshot: userRole,
        targetId: id,
        metadata: { error: (error as Error).message },
      });
      throw error;
    }
  }
  async createTeachingAssignment(
    assignmentData: Partial<ITeachingAssignment>,
    userId: string,
    userRole: string
  ) {
    try {
      const assignment = await this.teachingAssignmentRepository.create(
        assignmentData
      );
      const classId = await this.classRepository.findById(
        assignment.classId.toString()
      );
      const teacherId = await this.teacherRepository.findById(
        assignment.teacherId.toString()
      );
      if (!classId || !teacherId) {
        throw new Error("Class or Teacher not found");
      }

      if (teacherId.schoolId?.toString() !== classId.schoolId.toString()) {
        throw new Error("Teacher and class must belong to the same school");
      }

      await this.logger.log({
        userId,
        action: "CREATE_TEACHING_ASSIGNMENTS",
        roleSnapshot: userRole,
        metadata: { found: !!assignment },
      });
      return assignment;
    } catch (error) {
      await this.logger.log({
        userId,
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
    userId: string,
    userRole: string
  ) {
    try {
      if (!assignmentData || Object.keys(assignmentData).length === 0) {
        throw new Error("Teaching assignment data is required");
      }

      const teacher = await this.teacherRepository.findById(assignmentData.teacherId?.toString() || '');
      const user = await findUserByUserId(userId);

      if (!teacher || !user) {
        throw new Error("Teacher or user not found");
      }

      const assignment = await this.teachingAssignmentRepository.update(
        id,
        assignmentData
      );

      await this.logger.log({
        userId,
        action: "UPDATE_TEACHING_ASSIGNMENTS",
        roleSnapshot: userRole,
        targetId: id,
        metadata: { found: !!assignment },
      });

      return assignment;
    } catch (error) {
      await this.logger.log({
        userId,
        action: "UPDATE_TEACHING_ASSIGNMENTS_FAILED",
        roleSnapshot: userRole,
        targetId: id,
        metadata: { error: (error as Error).message },
      });
      throw error;
    }
  }

  async deleteTeachingAssignment(id: string, userId: string, userRole: string) {
    try {
      const assignment = await this.teachingAssignmentRepository.delete(id);

      await this.logger.log({
        userId,
        action: "DELETE_TEACHING_ASSIGNMENTS",
        roleSnapshot: userRole,
        targetId: id,
        metadata: { found: !!assignment },
      });
      return assignment;
    } catch (error) {
      await this.logger.log({
        userId,
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
