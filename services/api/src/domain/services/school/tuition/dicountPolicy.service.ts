import { PaginationQueryOptions } from "../../../../common/utils/buildQueryOptions";
import { DefaultLogger } from "../../../../common/utils/DefaultLogger";
import { buildPermissionFilterForFeeAndPolicy } from "../../../../common/utils/permissionFilter";
import { IDiscountPolicy } from "../../../models";
import DiscountPolicyRepository from "../../../repositories/school/tuition/discountPolicy.repository";

class DiscountPolicyService {
  private readonly discountPolicyRepository: DiscountPolicyRepository;
  private readonly logger: DefaultLogger;
  constructor(
    discountPolicyRepository: DiscountPolicyRepository,
    logger: DefaultLogger
  ) {
    this.discountPolicyRepository = discountPolicyRepository;
    this.logger = logger;
  }

  async getAllDisCountPolicy(
    actorId: string,
    userRole: string,
    schoolId?: string,
    options?: PaginationQueryOptions
  ) {
    try {
      const filter = buildPermissionFilterForFeeAndPolicy(userRole, schoolId);

      const discountPolicies = await this.discountPolicyRepository.findAll(
        filter,
        options
      );

      await this.logger.log({
        userId: actorId,
        action: "GET_ALL_DISCOUNT_POLICIES",
        roleSnapshot: userRole,
        metadata: { count: discountPolicies.length },
      });
      return discountPolicies;
    } catch (error) {
      await this.logger.log({
        userId: actorId,
        action: "GET_ALL_DISCOUNT_POLICIES_FAILED",
        roleSnapshot: userRole,
        metadata: { error: (error as Error).message },
      });
      throw error;
    }
  }

  async getDisCountPolicyById(id: string, actorId: string, userRole: string) {
    try {
      const discountPolicy = await this.discountPolicyRepository.findById(id);
      await this.logger.log({
        userId: actorId,
        action: "GET_DISCOUNT_POLICY_BY_ID",
        roleSnapshot: userRole,
        targetId: id,
        metadata: { found: discountPolicy },
      });
      return discountPolicy;
    } catch (error) {
      await this.logger.log({
        userId: actorId,
        action: "GET_DISCOUNT_POLICY_BY_ID_FAILED",
        roleSnapshot: userRole,
        targetId: id,
        metadata: { error: (error as Error).message },
      });
      throw error;
    }
  }

  async createDisCountPolicy(
    discountPolicyData: Partial<IDiscountPolicy>,
    actorId: string,
    userRole: string
  ) {
    try {
      const discountPolicy = await this.discountPolicyRepository.create(
        discountPolicyData
      );
      await this.logger.log({
        userId: actorId,
        action: "CREATE_DISCOUNT_POLICY",
        roleSnapshot: userRole,
        metadata: { found: discountPolicy },
      });
      return discountPolicy;
    } catch (error) {
      await this.logger.log({
        userId: actorId,
        action: "CREATE_DISCOUNT_POLICY_FAILED",
        roleSnapshot: userRole,
        metadata: { error: (error as Error).message },
      });
      throw error;
    }
  }

  async updateDisCountPolicy(
    discountPolicyData: Partial<IDiscountPolicy>,
    discountPolicyId: string,
    actorId: string,
    userRole: string
  ) {
    try {
      const discountPolicy = await this.discountPolicyRepository.update(
        discountPolicyId,
        discountPolicyData
      );
      await this.logger.log({
        userId: actorId,
        action: "UPDATE_DISCOUNT_POLICY",
        roleSnapshot: userRole,
        targetId: discountPolicyId,
        metadata: { found: discountPolicy },
      });
      return discountPolicy;
    } catch (error) {
      await this.logger.log({
        userId: actorId,
        action: "UPDATE_DISCOUNT_POLICY_FAILED",
        roleSnapshot: userRole,
        targetId: discountPolicyId,
        metadata: { error: (error as Error).message },
      });
      throw error;
    }
  }

  async deleteDisCountPolicy(
    discountPolicyId: string,
    actorId: string,
    userRole: string
  ) {
    try {
      const discountPolicy = await this.discountPolicyRepository.delete(
        discountPolicyId
      );
      await this.logger.log({
        userId: actorId,
        action: "DELETE_DISCOUNT_POLICY",
        roleSnapshot: userRole,
        targetId: discountPolicyId,
        metadata: { found: discountPolicy },
      });
      return discountPolicy;
    } catch (error) {
      await this.logger.log({
        userId: actorId,
        action: "DELETE_DISCOUNT_POLICY_FAILED",
        roleSnapshot: userRole,
        targetId: discountPolicyId,
        metadata: { error: (error as Error).message },
      });
      throw error;
    }
  }
}

export default DiscountPolicyService;
