import { PaginationQueryOptions } from "../../../common/utils/buildQueryOptions";
import { DefaultLogger } from "../../../common/utils/DefaultLogger";
import { buildPermissionFilter } from "../../../common/utils/permissionFilter";
import { IGrade } from "../../models";
import { GradeRepository } from "../../repositories";

class GradeService {
  private readonly gradeRepository: GradeRepository;
  private readonly logger: DefaultLogger;

  constructor(gradeRepository: GradeRepository, logger: DefaultLogger) {
    this.gradeRepository = gradeRepository;
    this.logger = logger;
  }

  // 🔹 Lấy tất cả khối
  async getAllGrades(
    actorId: string,
    userRole: string,
    schoolId?: string,
    options?: PaginationQueryOptions
  ) {
    try {
      const filter = buildPermissionFilter(userRole, schoolId);

      const grades = await this.gradeRepository.findAll(filter, options);

      await this.logger.log({
        userId: actorId,
        action: "GET_ALL_GRADE",
        roleSnapshot: userRole,
        metadata: { count: grades.length, options, filter },
      });

      return grades;
    } catch (error) {
      await this.logger.log({
        userId: actorId,
        action: "GET_ALL_GRADE_FAILED",
        roleSnapshot: userRole,
        metadata: { error: (error as Error).message },
      });
      throw error;
    }
  }

  async getGradesForSelect(
    actorId: string,
    userRole: string,
    schoolId?: string
  ) {
    try {
      const grades = await this.gradeRepository.findForSelect(schoolId);

      await this.logger.log({
        userId: actorId,
        action: "GET_GRADES_FOR_SELECT",
        roleSnapshot: userRole,
        metadata: { count: grades.length, schoolId },
      });

      return grades;
    } catch (error) {
      await this.logger.log({
        userId: actorId,
        action: "GET_GRADES_FOR_SELECT_FAILED",
        roleSnapshot: userRole,
        metadata: { error: (error as Error).message },
      });
      throw error;
    }
  }

  // 🔹 Lấy khối theo ID
  async getGradeById(id: string, actorId: string, userRole: string) {
    try {
      const grade = await this.gradeRepository.findById(id);

      await this.logger.log({
        userId: actorId,
        action: "GET_GRADE_BY_ID",
        targetId: id,
        roleSnapshot: userRole,
        metadata: { found: !!grade },
      });

      return grade;
    } catch (error) {
      await this.logger.log({
        userId: actorId,
        action: "GET_GRADE_BY_ID_FAILED",
        targetId: id,
        roleSnapshot: userRole,
        metadata: { error: (error as Error).message },
      });
      throw error;
    }
  }

  // 🔹 Tạo mới khối
  async createGrade(
    gradeData: Partial<IGrade>,
    actorId: string,
    userRole: string
  ) {
    try {
      const newGrade = await this.gradeRepository.create(gradeData);

      await this.logger.log({
        userId: actorId,
        action: "POST_GRADE",
        roleSnapshot: userRole,
        metadata: { createdId: newGrade._id },
      });

      return newGrade;
    } catch (error) {
      await this.logger.log({
        userId: actorId,
        action: "POST_GRADE_FAILED",
        roleSnapshot: userRole,
        metadata: { error: (error as Error).message },
      });
      throw error;
    }
  }

  // 🔹 Cập nhật khối
  async updateGrade(
    id: string,
    gradeData: Partial<IGrade>,
    actorId: string,
    userRole: string
  ) {
    try {
      const updatedGrade = await this.gradeRepository.update(id, gradeData);

      await this.logger.log({
        userId: actorId,
        action: "UPDATE_GRADE",
        targetId: id,
        roleSnapshot: userRole,
        metadata: { found: !!updatedGrade },
      });

      return updatedGrade;
    } catch (error) {
      await this.logger.log({
        userId: actorId,
        action: "UPDATE_GRADE_FAILED",
        targetId: id,
        roleSnapshot: userRole,
        metadata: { error: (error as Error).message },
      });
      throw error;
    }
  }

  // 🔹 Xoá khối
  async deleteGrade(id: string, actorId: string, userRole: string) {
    try {
      const deletedGrade = await this.gradeRepository.delete(id);

      await this.logger.log({
        userId: actorId,
        action: "DELETE_GRADE",
        targetId: id,
        roleSnapshot: userRole,
        metadata: { found: !!deletedGrade },
      });

      return deletedGrade;
    } catch (error) {
      await this.logger.log({
        userId: actorId,
        action: "DELETE_GRADE_FAILED",
        targetId: id,
        roleSnapshot: userRole,
        metadata: { error: (error as Error).message },
      });
      throw error;
    }
  }
}

export default GradeService;
