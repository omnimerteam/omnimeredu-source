import chalk from "chalk";
import { PaginationQueryOptions } from "../../../../common/utils/buildQueryOptions";
import { DefaultLogger } from "../../../../common/utils/DefaultLogger";
import { HttpError } from "../../../../common/utils/HttpError";
import { buildPermissionFilterForClass } from "../../../../common/utils/permissionFilter";
import { ITeachingAssignment } from "../../../models";

import {
  TeachingAssignmentRepository,
  ClassRepository,
  TeacherRepository,
} from "../../../repositories";
import { Types } from "mongoose";

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
  async getAllTeachingAssignments(
    actorId: string,
    userRole: string,
    schoolId?: string,
    option?: PaginationQueryOptions
  ) {
    try {
      const filter = buildPermissionFilterForClass(userRole, schoolId);

      const assignments = await this.teachingAssignmentRepository.findAll(
        filter,
        option
      );

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

  async getTeachingAssignmentByTeacherClassAndSchool(
    actorId: string,
    userRole: string,
    teacherId: string,
    schoolId: string,
    classId: string
  ) {
    try {
      const assignment = await this.teachingAssignmentRepository.findOne({
        teacherId,
        schoolId,
        classId,
      });

      await this.logger.log({
        userId: actorId,
        action: "GET_TEACHING_ASSIGNMENTS_BY_TEACHER_SCHOOL_ID",
        roleSnapshot: userRole,
        targetId: assignment?.id,
        metadata: { found: !!assignment },
      });
      return assignment;
    } catch (error) {
      await this.logger.log({
        userId: actorId,
        action: "GGET_TEACHING_ASSIGNMENTS_BY_TEACHER_SCHOOL_ID_FAILED",
        roleSnapshot: userRole,
        metadata: { error: (error as Error).message },
      });
      throw error;
    }
  }

  async createTeachingAssignment(
    assignmentData: ITeachingAssignment,
    schoolId: string,
    actorId: string,
    userRole: string
  ) {
    try {
      const classId = await this.classRepository.findById(
        assignmentData.classId.toString()
      );
      if (!classId) {
        throw new HttpError(400, "Không tìm thấy lớp học theo ID này");
      }

      console.log(chalk.green("So sánh"));
      console.log("ClassId:", classId.schoolId.toString());
      console.log("SchoolId:", schoolId.toString());
      console.log("assignmentData:", assignmentData.schoolId.toString());

      if (
        schoolId != classId.schoolId.toString() ||
        schoolId != assignmentData.schoolId.toString()
      ) {
        throw new HttpError(403, "Bạn không có quyền truy cập vào lớp học này");
      }

      const assignment = await this.teachingAssignmentRepository.create(
        assignmentData
      );

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
      const existingAssignment =
        await this.teachingAssignmentRepository.findById(id);

      if (!existingAssignment) {
        throw new HttpError(
          400,
          "Không tìm thấy bảng phân chia giảng dạy theo ID "
        );
      }

      if (existingAssignment!.schoolId.toString() != schoolId) {
        throw new HttpError(
          401,
          "Bạn không có quyền chỉnh sửa bảng phân chia giảng dạy của trường này"
        );
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
      const existingAssignment =
        await this.teachingAssignmentRepository.findById(id);

      if (!existingAssignment) {
        throw new HttpError(
          400,
          "Không tìm thấy bảng phân chia giảng dạy theo ID "
        );
      }

      if (existingAssignment!.schoolId.toString() !== schoolId) {
        throw new HttpError(
          401,
          "Bạn không có quyền xóa bảng phân chia giảng dạy của trường này"
        );
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
