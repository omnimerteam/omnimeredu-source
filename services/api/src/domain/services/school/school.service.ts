import { SchoolRepository } from "../../repositories";
import { ISchool } from "../../models";
import { DefaultLogger } from "../../../common/utils/DefaultLogger";
import { generateSchoolCode } from "../../utils/generateSchoolCode";

class SchoolService {
  private readonly schoolRepository: SchoolRepository;
  private readonly logger: DefaultLogger;

  constructor(SchoolRepository: SchoolRepository, logger: DefaultLogger) {
    this.schoolRepository = SchoolRepository;
    this.logger = logger;
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

  async getSchoolById(id: string, actorId: string, userRole: string) {
    try {
      const schoolData = await this.schoolRepository.findById(id);
      await this.logger.log({
        userId: actorId,
        action: "GET_SCHOOL_BY_ID",
        targetId: id,
        roleSnapshot: userRole,
        metadata: { found: !!schoolData },
      });

      return schoolData;
    } catch (error) {
      await this.logger.log({
        userId: actorId,
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
    actorId: string,
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
        userId: actorId,
        action: "GET_SCHOOL_BY_NAME_OR_CODE",
        targetId: name || code,
        roleSnapshot: userRole,
        metadata: { found: !!schoolData },
      });

      return schoolData;
    } catch (error) {
      await this.logger.log({
        userId: actorId,
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
    actorId: string,
    userRole: string
  ) {
    try {
      const code = generateSchoolCode(SchoolData.name || "XXX YYY ZZZ"); // Generate code from name

      const schoolData = await this.schoolRepository.create({
        ...SchoolData,
        code,
      });
      await this.logger.log({
        userId: actorId,
        action: "POST_SCHOOL",
        roleSnapshot: userRole,
        metadata: { found: !!schoolData },
      });

      return schoolData;
    } catch (error) {
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
    try {
      const schoolData = await this.schoolRepository.delete(id);
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
