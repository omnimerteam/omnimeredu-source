import { SchoolAdminRepository, SchoolRepository } from "../../repositories";
import { ISchool } from "../../models";
import { DefaultLogger } from "../../../common/utils/DefaultLogger";
import { generateSchoolCode } from "../../utils/generateCode";
import mongoose, { Types } from "mongoose";
import { HttpError } from "../../../common/utils/HttpError";
import { SchoolAdminPositionEnum } from "../../../common/enum/schoolAdmin.enum";

class SchoolService {
  private readonly schoolRepository: SchoolRepository;
  private readonly logger: DefaultLogger;
  private readonly schoolAdminRepository: SchoolAdminRepository;

  constructor(
    SchoolRepository: SchoolRepository,
    logger: DefaultLogger,
    schoolAdminRepository: SchoolAdminRepository
  ) {
    this.schoolRepository = SchoolRepository;
    this.logger = logger;
    this.schoolAdminRepository = schoolAdminRepository;
  }
  async getAllSchools(actorId: string, userRole: string) {
    try {
      const schools = await this.schoolRepository.findAll();
      await this.logger.log({
        userId: actorId,
        action: "GET_ALL_SCHOOLS",
        roleSnapshot: userRole,
        metadata: { count: schools.length },
      });

      return schools;
    } catch (error) {
      await this.logger.log({
        userId: actorId,
        action: "GET_ALL_SCHOOLS_FAILED",
        roleSnapshot: userRole,
        metadata: { error: (error as Error).message },
      });
      throw error;
    }
  }

  async getSchoolDetailForSchoolAdmin(
    id: string,
    actorId: string,
    userRole: string
  ) {
    try {
      const schoolData = await this.schoolRepository.findById(id);
      await this.logger.log({
        userId: actorId,
        action: "GET_SCHOOL_BY_ID_SCHOOL_ADMIN",
        targetId: id,
        roleSnapshot: userRole,
        metadata: { found: !!schoolData },
      });

      return schoolData;
    } catch (error) {
      await this.logger.log({
        userId: actorId,
        action: "GET_SCHOOL_BY_ID_SCHOOL_ADMIN_FAILED",
        targetId: id,
        roleSnapshot: userRole,
        metadata: { error: (error as Error).message },
      });
      throw error;
    }
  }
  //hàm này sẽ tìm kiếm theo tên hoặc mã trường học, nếu cả hai đều không có thì sẽ báo lỗi
  async searchSchoolByEducationLevel(educationLevel?: string, query?: string) {
    try {
      const schools = await this.schoolRepository.searchSchoolByEducationLevel(
        educationLevel,
        query
      );

      return schools;
    } catch (error) {
      throw error;
    }
  }

  async createSchool(
    SchoolData: Partial<ISchool>,
    actorId: string,
    userRole: string
  ) {
    const session = await mongoose.startSession();
    session.startTransaction();

    try {
      const code = generateSchoolCode(SchoolData.name || "XXX YYY ZZZ");

      // 1. Tạo School
      const newSchool = await this.schoolRepository.createWithSession(
        {
          ...SchoolData,
          adminId: new Types.ObjectId(SchoolData.adminId),
          code: code,
        },
        session
      );

      // 2. Update SchoolAdmin
      await this.schoolAdminRepository.updateByUserId(
        actorId,
        {
          schoolId: newSchool._id,
          position: SchoolAdminPositionEnum.Owner,
        },
        session
      );

      // 3. Commit transaction
      await session.commitTransaction();
      session.endSession();

      // 4. Log activity
      await this.logger.log({
        userId: actorId,
        action: "POST_SCHOOL",
        roleSnapshot: userRole,
        metadata: { found: !!newSchool },
      });

      return newSchool;
    } catch (error) {
      // Rollback khi lỗi
      await session.abortTransaction();
      session.endSession();

      await this.logger.log({
        userId: actorId,
        action: "POST_SCHOOL_FAILED",
        roleSnapshot: userRole,
        metadata: { error: (error as Error).message },
      });

      throw error;
    }
  }

  async updateSchool(
    id: string,
    SchoolData: Partial<ISchool>,
    actorId: string,
    userRole: string
  ) {
    try {
      const schoolData = await this.schoolRepository.update(id, SchoolData);
      await this.logger.log({
        userId: actorId,
        action: "UPDATE_SCHOOL",
        targetId: id,
        roleSnapshot: userRole,
        metadata: { found: !!schoolData },
      });

      return schoolData;
    } catch (error) {
      await this.logger.log({
        userId: actorId,
        action: "UPDATE_SCHOOL_FAILED",
        targetId: id,
        roleSnapshot: userRole,
        metadata: { error: (error as Error).message },
      });
      throw error;
    }
  }

  async deleteSchool(id: string, actorId: string, userRole: string) {
    const session = await mongoose.startSession();
    session.startTransaction();
    try {
      const schoolData = await this.schoolRepository.deleteWithSession(
        id,
        session
      );

      if (!schoolData) {
        throw new HttpError(404, "Không tìm thấy document để xoá");
      }

      // 2. Update SchoolAdmin
      await this.schoolAdminRepository.updateByUserId(
        actorId,
        { schoolId: null },
        session
      );

      // 3. Commit transaction
      await session.commitTransaction();
      session.endSession();

      await this.logger.log({
        userId: actorId,
        action: "DELETE_SCHOOL",
        targetId: id,
        roleSnapshot: userRole,
        metadata: { found: !!schoolData },
      });

      return schoolData;
    } catch (error) {
      await this.logger.log({
        userId: actorId,
        action: "DELETE_SCHOOL_FAILED",
        targetId: id,
        roleSnapshot: userRole,
        metadata: { error: (error as Error).message },
      });
      throw error;
    }
  }
}

export default SchoolService;
