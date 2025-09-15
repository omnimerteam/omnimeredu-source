import { DefaultLogger } from "../../../common/utils/DefaultLogger.js";
import { TeacherRepository } from "../../repositories/index.js";
import { ITeacher } from "../../models";
import { PaginationQueryOptions } from "../../../common/utils/buildQueryOptions";
import { buildPermissionFilter } from "../../../common/utils/permissionFilter";

class TeacherService {
  private readonly logger: DefaultLogger;
  private readonly teacherRepository: TeacherRepository;

  constructor(
    TeacherRepository: TeacherRepository,
    DefaultLogger: DefaultLogger
  ) {
    this.logger = DefaultLogger;
    this.teacherRepository = TeacherRepository;
  }

  async getAllTeachers(
    actorId: string,
    userRole: string,
    schoolId?: string,
    options?: PaginationQueryOptions
  ) {
    try {
      const filter = buildPermissionFilter(userRole, schoolId);

      const teachers = await this.teacherRepository.findAll(filter, options);

      await this.logger.log({
        userId: actorId,
        action: "GET_ALL_TEACHERS",
        roleSnapshot: userRole,
        metadata: { filter, options, count: teachers.length },
      });

      return teachers;
    } catch (error) {
      await this.logger.log({
        userId: actorId,
        action: "GET_ALL_TEACHERS_FAILED",
        roleSnapshot: userRole,
        metadata: { error: (error as Error).message },
      });
      throw error;
    }
  }

  async getTeacherById(id: string, actorId: string, userRole: string) {
    try {
      const teacher = await this.teacherRepository.findById(id);
      if (!teacher) {
        throw new Error(`Teacher with ID ${id} not found`);
      }
      await this.logger.log({
        userId: actorId,
        action: "GET_TEACHER_BY_ID",
        targetId: id,
        roleSnapshot: userRole,
        metadata: { found: !!teacher },
      });
      return teacher;
    } catch (error) {
      await this.logger.log({
        userId: actorId,
        action: "GET_TEACHER_BY_ID_FAILED",
        targetId: id,
        roleSnapshot: userRole,
        metadata: { error: (error as Error).message },
      });
      throw error;
    }
  }

  async createTeacher(
    TeacherData: Partial<ITeacher>,
    actorId: string,
    userRole: string
  ) {
    try {
      const teacherData = await this.teacherRepository.create(TeacherData);

      await this.logger.log({
        userId: actorId,
        action: "POST_TEACHER",
        roleSnapshot: userRole,
        metadata: { found: !!teacherData },
      });
      return teacherData;
    } catch (error) {
      await this.logger.log({
        userId: actorId,
        action: "POST_TEACHER_FAILED",
        roleSnapshot: userRole,
        metadata: { error: (error as Error).message },
      });
      throw error;
    }
  }

  async updateTeacher(
    id: string,
    TeacherData: Partial<ITeacher>,
    actorId: string,
    userRole: string
  ) {
    try {
      const teacherData = await this.teacherRepository.update(id, TeacherData);
      if (!teacherData) {
        throw new Error(`Teacher with ID ${id} not found`);
      }
      await this.logger.log({
        userId: actorId,
        action: "UPDATE_TEACHER",
        targetId: id,
        roleSnapshot: userRole,
        metadata: { found: !!teacherData },
      });
      return teacherData;
    } catch (error) {
      await this.logger.log({
        userId: actorId,
        action: "UPDATE_TEACHER_FAILED",
        targetId: id,
        roleSnapshot: userRole,
        metadata: { error: (error as Error).message },
      });
      throw error;
    }
  }

  async deleteTeacher(id: string, actorId: string, userRole: string) {
    try {
      const teacherData = await this.teacherRepository.delete(id);
      if (!teacherData) {
        throw new Error(`Teacher with ID ${id} not found`);
      }
      await this.logger.log({
        userId: actorId,
        action: "DELETE_TEACHER",
        targetId: id,
        roleSnapshot: userRole,
        metadata: { found: !!teacherData },
      });
      return teacherData;
    } catch (error) {
      await this.logger.log({
        userId: actorId,
        action: "DELETE_TEACHER_FAILED",
        targetId: id,
        roleSnapshot: userRole,
        metadata: { error: (error as Error).message },
      });
      throw error;
    }
  }
}
export default TeacherService;
