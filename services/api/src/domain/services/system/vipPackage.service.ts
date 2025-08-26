import { DefaultLogger } from "../../../common/utils/DefaultLogger";
import { IVipPackage } from "../../models";
import { VipPackageRepository } from "../../repositories";

class VipPackageService {
  private readonly vipPackageRepository: VipPackageRepository;
  private readonly logger: DefaultLogger;
  constructor(
    vipPackageRepository: VipPackageRepository,
    logger: DefaultLogger
  ) {
    this.vipPackageRepository = vipPackageRepository;
    this.logger = logger;
  }

  async getAllVipPackages(
    actorId: string,
    userRole: string,
    options?: { page?: number; limit?: number; sort?: any }
  ) {
    try {
      const vipPackage = await this.vipPackageRepository.findAll({}, options);

      await this.logger.log({
        userId: actorId,
        action: "GET_ALL_VIPPACKAGE",
        roleSnapshot: userRole,
        metadata: { count: vipPackage.length, options: options },
      });

      return vipPackage;
    } catch (error) {
      await this.logger.log({
        userId: actorId,
        action: "GET_ALL_VIPPACKAGE_FAILED",
        roleSnapshot: userRole,
        metadata: { error: (error as Error).message },
      });
      throw error;
    }
  }

  async getVipPackageById(id: string, actorId: string, userRole: string) {
    try {
      const vipPackage = await this.vipPackageRepository.findById(id);
      await this.logger.log({
        userId: actorId,
        action: "GET_VIPPACKAGE_BY_ID",
        targetId: id,
        roleSnapshot: userRole,
        metadata: { found: !!vipPackage },
      });

      return vipPackage;
    } catch (error) {
      await this.logger.log({
        userId: actorId,
        action: "GET_VIPPACKAGE_BY_ID_FAILED",
        targetId: id,
        roleSnapshot: userRole,
        metadata: { error: (error as Error).message },
      });
      throw error;
    }
  }

  async createVipPackage(
    VipPackageData: Partial<IVipPackage>,
    actorId: string,
    userRole: string
  ) {
    try {
      const newVipPackage = await this.vipPackageRepository.create(
        VipPackageData
      );
      await this.logger.log({
        userId: actorId,
        action: "POST_VIPPACKAGE",
        roleSnapshot: userRole,
        metadata: { found: !!newVipPackage },
      });

      return newVipPackage;
    } catch (error) {
      await this.logger.log({
        userId: actorId,
        action: "POST_VIPPACKAGE_FAILED",
        roleSnapshot: userRole,
        metadata: { error: (error as Error).message },
      });
      throw error;
    }
  }

  async updateVipPackage(
    id: string,
    VipPackageData: Partial<IVipPackage>,
    actorId: string,
    userRole: string
  ) {
    try {
      const updatedVipPackage = await this.vipPackageRepository.update(
        id,
        VipPackageData
      );
      await this.logger.log({
        userId: actorId,
        action: "UPDATE_VIPPACKAGE",
        targetId: id,
        roleSnapshot: userRole,
        metadata: { found: !!updatedVipPackage },
      });

      return updatedVipPackage;
    } catch (error) {
      await this.logger.log({
        userId: actorId,
        action: "UPDATE_VIPPACKAGE_FAILED",
        targetId: id,
        roleSnapshot: userRole,
        metadata: { error: (error as Error).message },
      });
      throw error;
    }
  }

  async deleteVipPackage(id: string, actorId: string, userRole: string) {
    try {
      const deletedVipPackage = await this.vipPackageRepository.delete(id);
      await this.logger.log({
        userId: actorId,
        action: "DELETE_VIPPACKAGE",
        targetId: id,
        roleSnapshot: userRole,
        metadata: { found: !!deletedVipPackage },
      });

      return deletedVipPackage;
    } catch (error) {
      await this.logger.log({
        userId: actorId,
        action: "DELETE_VIPPACKAGE_FAILED",
        targetId: id,
        roleSnapshot: userRole,
        metadata: { error: (error as Error).message },
      });
      throw error;
    }
  }
}

export default VipPackageService;
