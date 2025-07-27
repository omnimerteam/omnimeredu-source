import SchoolRepository from "../repositories/school.repository";
import { ISchool } from "../models/School";
import { ILogger } from "../interfaces/logger.interface";

class SchoolService {
  private readonly schoolRepository: SchoolRepository;
  private readonly logger: ILogger;

  constructor(SchoolRepository: SchoolRepository, logger: ILogger) {
    this.schoolRepository = SchoolRepository;
    this.logger = logger;
  }
  async getAllSchools(userId: string, userRole: string) {
    try {
      const schools = await this.schoolRepository.findAll();
      await this.logger.log({
        userId,
        action: "GET_ALL_SCHOOLS",
        roleSnapshot: userRole,
        metadata: { count: schools.length },
      });

      return schools;
    } catch (error) {
      await this.logger.log({
        userId,
        action: "GET_ALL_SCHOOLS_FAILED",
        roleSnapshot: userRole,
        metadata: { error: (error as Error).message },
      });
      throw error;
    }
  }

  async getSchoolById(id: string, userId: string, userRole: string) {
    try {
      const schoolData = await this.schoolRepository.findById(id);
      await this.logger.log({
        userId,
        action: "GET_SCHOOL_BY_ID",
        targetId: id,
        roleSnapshot: userRole,
        metadata: { found: !!schoolData },
      });

      return schoolData;
    } catch (error) {
      await this.logger.log({
        userId,
        action: "GET_SCHOOL_BY_ID_FAILED",
        targetId: id,
        roleSnapshot: userRole,
        metadata: { error: (error as Error).message },
      });
      throw error;
    }
  }
  //hàm này sẽ tìm kiếm theo tên hoặc mã trường học, nếu cả hai đều không có thì sẽ báo lỗi
  async getSchoolByNameOrCode(
    name: string,
    code: string,
    userId: string,
    userRole: string
  ) {
    try {
      const schoolData = await this.schoolRepository.findByNameOrCode(
        name,
        code
      );
      if (!name && !code) {
        throw new Error("Either name or code must be provided");
      }
      await this.logger.log({
        userId,
        action: "GET_SCHOOL_BY_NAME_OR_CODE",
        targetId: name || code,
        roleSnapshot: userRole,
        metadata: { found: !!schoolData },
      });

      return schoolData;
    } catch (error) {
      await this.logger.log({
        userId,
        action: "GET_SCHOOL_BY_NAME_OR_CODE_FAILED",
        targetId: name || code,
        roleSnapshot: userRole,
        metadata: { error: (error as Error).message },
      });
      throw error;
    }
  }

  async createSchool(
    SchoolData: Partial<ISchool>,
    userId: string,
    userRole: string
  ) {
    try {
      const schoolData = await this.schoolRepository.create(SchoolData);
      await this.logger.log({
        userId,
        action: "POST_SCHOOL",
        roleSnapshot: userRole,
        metadata: { found: !!schoolData },
      });

      return schoolData;
    } catch (error) {
      await this.logger.log({
        userId,
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
    userId: string,
    userRole: string
  ) {
    try {
      const schoolData = await this.schoolRepository.update(id, SchoolData);
      await this.logger.log({
        userId,
        action: "UPDATE_SCHOOL",
        targetId: id,
        roleSnapshot: userRole,
        metadata: { found: !!schoolData },
      });

      return schoolData;
    } catch (error) {
      await this.logger.log({
        userId,
        action: "UPDATE_SCHOOL_FAILED",
        targetId: id,
        roleSnapshot: userRole,
        metadata: { error: (error as Error).message },
      });
      throw error;
    }
  }

  async deleteSchool(id: string, userId: string, userRole: string) {
    try {
      const schoolData = await this.schoolRepository.delete(id);
      await this.logger.log({
        userId,
        action: "DELETE_SCHOOL",
        targetId: id,
        roleSnapshot: userRole,
        metadata: { found: !!schoolData },
      });

      return schoolData;
    } catch (error) {
      await this.logger.log({
        userId,
        action: "DELETE_SCHOOL_FAILED",
        targetId: id,
        roleSnapshot: userRole,
        metadata: { error: (error as Error).message },
      });
      throw error;
    }
  }
}
//ở đây chỉ export ra 1 class duy nhất, không cần phải export từng hàm
export default SchoolService;
