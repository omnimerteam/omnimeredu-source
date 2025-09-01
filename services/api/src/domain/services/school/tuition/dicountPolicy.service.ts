import { DefaultLogger } from "../../../../common/utils/DefaultLogger";
import { IDiscountPolicy } from "../../../models";
import DiscountPolicyRepository from "../../../repositories/school/tuition/discountPolicy.repository";
import SchoolAdminRepository from "../../../repositories/user/schoolAdmin.repository";

class DiscountPolicyService{
    private readonly discountPolicyRepository: DiscountPolicyRepository;
    private readonly schoolAdminRepository: SchoolAdminRepository;
    private readonly logger: DefaultLogger;
    constructor(discountPolicyRepository: DiscountPolicyRepository, schoolAdminRepository: SchoolAdminRepository, logger: DefaultLogger){
        this.discountPolicyRepository = discountPolicyRepository;
        this.schoolAdminRepository = schoolAdminRepository;
        this.logger = logger;
    }

    async getAllDisCountPolicy(actorId: string, schoolId: string, userRole: string){
        try {
           
            if(userRole !== "SuperAdmin"){
                const currentActor = await this.schoolAdminRepository.findById(actorId);
                if(!currentActor){
                    throw new Error("User Not Found");
                }

                const actorSchoolId = currentActor.schoolId?.toString();
                if(actorSchoolId !== schoolId){
                    throw new Error("You do not permission in this school. ");
                }
            }
            const discountPolicies = await this.discountPolicyRepository.findAll();
            await this.logger.log({
                userId: actorId,
                action: "GET_ALL_DISCOUNT_POLICIES",
                roleSnapshot: userRole,
                metadata: {count: discountPolicies.length}
            })
            return discountPolicies;
        } catch (error) {
            await this.logger.log({
                userId: actorId,
                action: "GET_ALL_DISCOUNT_POLICIES_FAILED",
                roleSnapshot: userRole,
                metadata: {error: (error as Error).message}
            })
            throw error;
        }
    }

    async getDisCountPolicyById(id: string, actorId: string, userRole: string){
        try {
            const discountPolicy = await this.discountPolicyRepository.findById(id);
            await this.logger.log({
                userId: actorId,
                action: "GET_DISCOUNT_POLICY_BY_ID",
                roleSnapshot: userRole,
                targetId: id,
                metadata: {found: discountPolicy}
            })
            return discountPolicy;
        } catch (error) {
            await this.logger.log({
                userId: actorId,
                action: "GET_DISCOUNT_POLICY_BY_ID_FAILED",
                roleSnapshot: userRole,
                targetId: id,
                metadata: {error: (error as Error).message}
            })
            throw error;
        }
    }

    async createDisCountPolicy(discoutPolicyData: Partial<IDiscountPolicy>, actorId: string, userRole: string){
        try {
            const discountPolicy = await this.discountPolicyRepository.create(discoutPolicyData);
            await this.logger.log({
                userId: actorId,
                action: "CREATE_DISCOUNT_POLICY",
                roleSnapshot: userRole,
                metadata: {found: discountPolicy}
            })
            return discountPolicy;
        } catch (error) {
            await this.logger.log({
                userId: actorId,
                action: "CREATE_DISCOUNT_POLICY_FAILED",
                roleSnapshot: userRole,
                metadata: {error: (error as Error).message}
            })
            throw error;
        }
    }

    async updateDisCountPolicy(discoutPolicyData: Partial<IDiscountPolicy>, discountPolicyId: string, actorId: string, userRole: string){
        try {
            const discountPolicy = await this.discountPolicyRepository.update(discountPolicyId, discoutPolicyData);
            await this.logger.log({
                userId: actorId,
                action: "UPDATE_DISCOUNT_POLICY",
                roleSnapshot: userRole,
                targetId: discountPolicyId,
                metadata: {found: discountPolicy}
            })
            return discountPolicy;
        } catch (error) {
            await this.logger.log({
                userId: actorId,
                action: "UPDATE_DISCOUNT_POLICY_FAILED",
                roleSnapshot: userRole,
                targetId: discountPolicyId,
                metadata: {error: (error as Error).message}
            })
            throw error;
        }
    }

    async deleteDisCountPolicy(discountPolicyId: string, actorId: string, userRole: string){
        try {
            const discountPolicy = await this.discountPolicyRepository.delete(discountPolicyId);
            await this.logger.log({
                userId: actorId,
                action: "DELETE_DISCOUNT_POLICY",
                roleSnapshot: userRole,
                targetId: discountPolicyId,
                metadata: {found: discountPolicy}
            })
            return discountPolicy;
        } catch (error) {
            await this.logger.log({
                userId: actorId,
                action: "DELETE_DISCOUNT_POLICY_FAILED",
                roleSnapshot: userRole,
                targetId: discountPolicyId,
                metadata: {error: (error as Error).message}
            })
            throw error;
        }
    }
}

export default DiscountPolicyService;