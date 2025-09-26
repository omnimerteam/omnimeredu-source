import { DefaultLogger } from "../../../common/utils/DefaultLogger";
import { SchoolAdminRepository } from "../../repositories";
import { ISchoolAdmin } from "../../models";
import { SchoolAdminPositionEnum } from "../../../common/enum/schoolAdmin.enum";

class SchoolAdminService {
  private readonly schoolAdminRepository: SchoolAdminRepository;
  private readonly logger: DefaultLogger;
  constructor(
    logger: DefaultLogger,
    schoolAdminRepository: SchoolAdminRepository
  ) {
    this.logger = logger;
    this.schoolAdminRepository = schoolAdminRepository;
  }

  async getAllSchoolAdmins(actorId: string, userRole: string) {
    try {
      const schoolAdmins = await this.schoolAdminRepository.findAll();

      await this.logger.log({
        userId: actorId,
        action: "GET_ALL_SCHOOL_ADMINS",
        roleSnapshot: userRole,
        metadata: { SchoolAdmins: schoolAdmins.length },
      });

      return schoolAdmins;
    } catch (error) {
      await this.logger.log({
        userId: actorId,
        action: "GET_ALL_SCHOOL_ADMINS_FAILED",
        roleSnapshot: userRole,
        metadata: { error: (error as Error).message },
      });
      throw error;
    }
  }

  async getSchoolAdminById(
    schoolAdminId: string,
    actorId: string,
    userRole: string
  ) {
    try {
      const schoolAdmin = await this.schoolAdminRepository.findById(
        schoolAdminId
      );
      await this.logger.log({
        userId: actorId,
        action: "GET_ALL_SCHOOL_ADMIN_BY_ID",
        roleSnapshot: userRole,
        targetId: schoolAdminId,
        metadata: { SchoolAdmins: !!schoolAdmin },
      });
      return schoolAdmin;
    } catch (error) {
      await this.logger.log({
        userId: actorId,
        action: "GET_ALL_SCHOOL_ADMIN_BY_ID_FAILED",
        roleSnapshot: userRole,
        targetId: schoolAdminId,
        metadata: { error: (error as Error).message },
      });
      throw error;
    }
  }
  async createSchoolAdmin(
    SchoolAdminData: Partial<ISchoolAdmin>,
    actorId: string,
    userRole: string
  ) {
    try {
      const schoolAdmin = await this.schoolAdminRepository.create(
        SchoolAdminData
      );
      await this.logger.log({
        userId: actorId,
        action: "CREATE_SCHOOL_ADMIN",
        roleSnapshot: userRole,
        metadata: { SchoolAdmins: !!schoolAdmin },
      });
      return schoolAdmin;
    } catch (error) {
      await this.logger.log({
        userId: actorId,
        action: "CREATE_SCHOOL_ADMIN_FAILED",
        roleSnapshot: userRole,
        metadata: { error: (error as Error).message },
      });
      throw error;
    }
  }
  async updateSchoolAdmin(
    schoolAdminId: string,
    SchoolAdminData: Partial<ISchoolAdmin>,
    actorId: string,
    userRole: string
  ) {
    try {
      const schoolAdmin = await this.schoolAdminRepository.update(
        schoolAdminId,
        SchoolAdminData
      );
      await this.logger.log({
        userId: actorId,
        action: "UPDATE_SCHOOL_ADMIN",
        roleSnapshot: userRole,
        targetId: schoolAdminId,
        metadata: { SchoolAdmins: !!schoolAdmin },
      });
      return schoolAdmin;
    } catch (error) {
      await this.logger.log({
        userId: actorId,
        action: "UPDATE_SCHOOL_ADMIN_FAILED",
        roleSnapshot: userRole,
        targetId: schoolAdminId,
        metadata: { error: (error as Error).message },
      });
      throw error;
    }
  }

  async updatePositionSchoolAdmin(
    actorId: string,
    userRole: string,
    schoolAdminId: string,
    position: SchoolAdminPositionEnum
  ) {
    try {
      const schoolAdmin = await this.schoolAdminRepository.update(
        schoolAdminId,
        { position }
      );
      await this.logger.log({
        userId: actorId,
        action: "UPDATE_POSITION_SCHOOL_ADMIN",
        roleSnapshot: userRole,
        targetId: schoolAdminId,
        metadata: { SchoolAdmins: !!schoolAdmin },
      });
      return schoolAdmin;
    } catch (error) {
      await this.logger.log({
        userId: actorId,
        action: "UPDATE_POSITION_SCHOOL_ADMIN_FAILED",
        roleSnapshot: userRole,
        targetId: schoolAdminId,
        metadata: { error: (error as Error).message },
      });
      throw error;
    }
  }

  async deleteSchoolAdmin(
    schoolAdminId: string,
    actorId: string,
    userRole: string
  ) {
    try {
      const schoolAdmin = await this.schoolAdminRepository.delete(
        schoolAdminId
      );
      await this.logger.log({
        userId: actorId,
        action: "DELETE_SCHOOL_ADMIN",
        roleSnapshot: userRole,
        targetId: schoolAdminId,
        metadata: { SchoolAdmins: !!schoolAdmin },
      });
      return schoolAdmin;
    } catch (error) {
      await this.logger.log({
        userId: actorId,
        action: "DELETE_SCHOOL_ADMIN_FAILED",
        roleSnapshot: userRole,
        targetId: schoolAdminId,
        metadata: { error: (error as Error).message },
      });
      throw error;
    }
  }
}
export default SchoolAdminService;
