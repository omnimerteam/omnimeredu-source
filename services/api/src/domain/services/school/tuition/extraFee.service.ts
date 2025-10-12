import { PaginationQueryOptions } from "../../../../common/utils/buildQueryOptions";
import { DefaultLogger } from "../../../../common/utils/DefaultLogger";
import { buildPermissionFilterForFeeAndPolicy } from "../../../../common/utils/permissionFilter";
import { IExtraFee } from "../../../models";
import ExtraFeeRepository from "../../../repositories/school/tuition/extraFee.repository";

class ExtraFeeService {
  private readonly extraFeeRepository: ExtraFeeRepository;
  private readonly logger: DefaultLogger;

  constructor(extraFeeRepository: ExtraFeeRepository, logger: DefaultLogger) {
    this.extraFeeRepository = extraFeeRepository;
    this.logger = logger;
  }

  async getAllExtraFees(
    actorId: string,
    schoolId: string,
    userRole: string,
    options?: PaginationQueryOptions
  ) {
    try {
      const filter = buildPermissionFilterForFeeAndPolicy(userRole, schoolId);

      const extraFees = await this.extraFeeRepository.findAll(filter, options);

      await this.logger.log({
        userId: actorId,
        action: "GET_ALL_EXTRA_FEE",
        roleSnapshot: userRole,
        metadata: { count: extraFees.length },
      });

      return extraFees;
    } catch (error) {
      await this.logger.log({
        userId: actorId,
        action: "GET_ALL_EXTRA_FEE_FAILED",
        roleSnapshot: userRole,
        metadata: { error: (error as Error).message },
      });
    }
  }

  async getExtraFeeById(id: string, actorId: string, userRole: string) {
    try {
      const extraFee = await this.extraFeeRepository.findById(id);
      await this.logger.log({
        userId: actorId,
        action: "GET_EXTRA_FEE_BY_ID",
        roleSnapshot: userRole,
        targetId: id,
        metadata: { found: extraFee },
      });
      return extraFee;
    } catch (error) {
      await this.logger.log({
        userId: actorId,
        action: "GET_EXTRA_FEE_BY_ID_FAILED",
        roleSnapshot: userRole,
        targetId: id,
        metadata: { error: (error as Error).message },
      });
    }
  }

  async createExtraFee(
    extraFeeData: Partial<IExtraFee>,
    actorId: string,
    userRole: string
  ) {
    try {
      const extraFee = await this.extraFeeRepository.create(extraFeeData);
      await this.logger.log({
        userId: actorId,
        action: "CREATE_EXTRA_FEE",
        roleSnapshot: userRole,
        metadata: { found: extraFee },
      });
      return extraFee;
    } catch (error) {
      await this.logger.log({
        userId: actorId,
        action: "CREATE_EXTRA_FEE_FAILED",
        roleSnapshot: userRole,
        metadata: { error: (error as Error).message },
      });
    }
  }

  async updateExtraFee(
    extraFeeData: Partial<IExtraFee>,
    extraFeeId: string,
    actorId: string,
    userRole: string
  ) {
    try {
      const extraFee = await this.extraFeeRepository.update(
        extraFeeId,
        extraFeeData
      );
      await this.logger.log({
        userId: actorId,
        action: "UPDATE_EXTRA_FEE",
        roleSnapshot: userRole,
        targetId: extraFeeId,
        metadata: { found: extraFee },
      });
      return extraFee;
    } catch (error) {
      await this.logger.log({
        userId: actorId,
        action: "UPDATE_EXTRA_FEE_FAILED",
        roleSnapshot: userRole,
        targetId: extraFeeId,
        metadata: { error: (error as Error).message },
      });
    }
  }

  async deleteExtraFee(extraFeeId: string, actorId: string, userRole: string) {
    try {
      const extraFee = await this.extraFeeRepository.delete(extraFeeId);
      await this.logger.log({
        userId: actorId,
        action: "DELETE_EXTRA_FEE",
        roleSnapshot: userRole,
        targetId: extraFeeId,
        metadata: { found: extraFee },
      });
      return extraFee;
    } catch (error) {
      await this.logger.log({
        userId: actorId,
        action: "DELETE_EXTRA_FEE_FAILED",
        roleSnapshot: userRole,
        targetId: extraFeeId,
        metadata: { error: (error as Error).message },
      });
    }
  }
}

export default ExtraFeeService;
