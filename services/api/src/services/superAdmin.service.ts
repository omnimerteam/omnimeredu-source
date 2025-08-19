import { DefaultLogger } from "../utils/DefaultLogger.js";
import SuperAdminRepository from "../repositories/superAdmin.repository.js";
import { ISuperAdmin } from "../models";
class SuperAdminService {
  private readonly logger: DefaultLogger;
  private readonly superAdminRepository: SuperAdminRepository;

  constructor(
    superAdminRepository: SuperAdminRepository,
    DefaultLogger: DefaultLogger
  ) {
    this.logger = DefaultLogger;
    this.superAdminRepository = superAdminRepository;
  }

  async getAllSuperAdmin(
    actorId: string,
    userRole: string,
    options?: { page?: number; limit?: number; sort?: any }
  ) {
    try {
      const superAdmins = await this.superAdminRepository.findAll({}, options);
      await this.logger.log({
        userId: actorId,
        action: "GET_ALL_SUPERADMIN",
        roleSnapshot: userRole,
        metadata: { count: superAdmins.length },
      });
      return superAdmins;
    } catch (error) {
      await this.logger.log({
        userId: actorId,
        action: "GET_ALL_SUPERADMIN_FAILED",
        roleSnapshot: userRole,
        metadata: { error: (error as Error).message },
      });
      throw error;
    }
  }

  async getSuperAdminById(id: string, actorId: string, userRole: string) {
    try {
      const superAdmin = await this.superAdminRepository.findById(id);
      if (!superAdmin) {
        throw new Error(`SuperAdmin with ID ${id} not found`);
      }
      await this.logger.log({
        userId: actorId,
        action: "GET_SUPERADMIN_BY_ID",
        targetId: id,
        roleSnapshot: userRole,
        metadata: { found: !!superAdmin },
      });
      return superAdmin;
    } catch (error) {
      await this.logger.log({
        userId: actorId,
        action: "GET_SUPERADMIN_BY_ID_FAILED",
        targetId: id,
        roleSnapshot: userRole,
        metadata: { error: (error as Error).message },
      });
      throw error;
    }
  }

  async createSuperAdmin(
    SuperAdminData: Partial<ISuperAdmin>,
    actorId: string,
    userRole: string
  ) {
    try {
      const newsSuperAdmin = await this.superAdminRepository.create(
        SuperAdminData
      );

      await this.logger.log({
        userId: actorId,
        action: "POST_SUPERADMIN",
        roleSnapshot: userRole,
        metadata: { found: !!newsSuperAdmin },
      });
      return newsSuperAdmin;
    } catch (error) {
      await this.logger.log({
        userId: actorId,
        action: "POST_SUPERADMIN_FAILED",
        roleSnapshot: userRole,
        metadata: { error: (error as Error).message },
      });
      throw error;
    }
  }

  async updateSuperAdmin(
    id: string,
    SuperAdminData: Partial<ISuperAdmin>,
    actorId: string,
    userRole: string
  ) {
    try {
      const updateSuperAdmin = await this.superAdminRepository.update(
        id,
        SuperAdminData
      );
      if (!updateSuperAdmin) {
        throw new Error(`SuperAdmin with ID ${id} not found`);
      }
      await this.logger.log({
        userId: actorId,
        action: "UPDATE_SUPERADMIN",
        targetId: id,
        roleSnapshot: userRole,
        metadata: { found: !!updateSuperAdmin },
      });

      return updateSuperAdmin;
    } catch (error) {
      await this.logger.log({
        userId: actorId,
        action: "UPDATE_SUPERADMIN_FAILED",
        targetId: id,
        roleSnapshot: userRole,
        metadata: { error: (error as Error).message },
      });
      throw error;
    }
  }

  async deleteSuperAdmin(id: string, actorId: string, userRole: string) {
    try {
      const deleteSuperAdmin = await this.superAdminRepository.delete(id);
      if (!deleteSuperAdmin) {
        throw new Error(`SuperAdmin with ID ${id} not found`);
      }
      await this.logger.log({
        userId: actorId,
        action: "DELETE_SUPERADMIN",
        targetId: id,
        roleSnapshot: userRole,
        metadata: { found: !!deleteSuperAdmin },
      });
      return deleteSuperAdmin;
    } catch (error) {
      await this.logger.log({
        userId: actorId,
        action: "DELETE_SUPERADMIN_FAILED",
        targetId: id,
        roleSnapshot: userRole,
        metadata: { error: (error as Error).message },
      });
      throw error;
    }
  }
}
export default SuperAdminService;
