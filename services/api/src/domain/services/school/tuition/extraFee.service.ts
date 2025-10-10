import { DefaultLogger } from "../../../../common/utils/DefaultLogger";
import { IExtraFee } from "../../../models";
import ExtraFeeRepository from "../../../repositories/school/tuition/extraFee.repository";
import SchoolAdminRepository from "../../../repositories/user/schoolAdmin.repository";

class ExtraFeeService{
    private readonly extraFeeRepository: ExtraFeeRepository;
    private readonly schoolAdminRepository: SchoolAdminRepository;
    private readonly logger: DefaultLogger;

    constructor(extraFeeRepository: ExtraFeeRepository, schoolAdminRepository: SchoolAdminRepository, logger: DefaultLogger){
        this.extraFeeRepository = extraFeeRepository;
        this.schoolAdminRepository = schoolAdminRepository;
        this.logger = logger;
    }

    async getAllExtraFees(actorId: string, schoolId: string, userRole: string){
        try {
            if(userRole !== "SuperAdmin"){
                const currentActor = await this.schoolAdminRepository.findById(actorId);
                if(!currentActor){
                    throw new Error("User Not Found");
                }
                const actorSchoolId = currentActor.schoolId?.toString();
                if(actorSchoolId !== schoolId){
                    throw new Error ("You do not permission in this school !!");
                }
            }
            const extrafees = await this.extraFeeRepository.findAll();
            await this.logger.log({
                userId: actorId,
                action: "GET_ALL_EXTRA_FEE",
                roleSnapshot: userRole,
                metadata: {count: extrafees.length}
            });
            return extrafees;
        } catch (error) {
            await this.logger.log({
                userId: actorId, 
                action: "GET_ALL_EXTRA_FEE_FAILED",
                roleSnapshot: userRole,
                metadata: {error: (error as Error).message}
            });
        }
    }

    async getExtraFeeById(id: string, actorId: string, userRole: string){
        try {
            const extrafee = await this.extraFeeRepository.findById(id);
            await this.logger.log({
                userId: actorId,
                action: "GET_EXTRA_FEE_BY_ID",
                roleSnapshot: userRole,
                targetId: id,
                metadata: {found: extrafee}
            });
            return extrafee;
        } catch (error) {
            await this.logger.log({
                userId: actorId, 
                action: "GET_EXTRA_FEE_BY_ID_FAILED",
                roleSnapshot: userRole,
                targetId: id, 
                metadata: {error: (error as Error).message}
            });
        }
    }

    async createExtraFee(extraFeeData: Partial<IExtraFee>, actorId: string, userRole: string){
        try {
            const extrafee = await this.extraFeeRepository.create(extraFeeData);
            await this.logger.log({
                userId: actorId,
                action: "CREATE_EXTRA_FEE",
                roleSnapshot: userRole,
                metadata: {found: extrafee}
            });
            return extrafee;
        } catch (error) {
            await this.logger.log({
                userId: actorId, 
                action: "CREATE_EXTRA_FEE_FAILED",
                roleSnapshot: userRole, 
                metadata: {error: (error as Error).message}
            });
        }
    }

    async updateExtraFee(extraFeeData: Partial<IExtraFee>, extraFeeId: string, actorId: string, userRole: string){
        try {
            const extrafee = await this.extraFeeRepository.update(extraFeeId, extraFeeData);
            await this.logger.log({
                userId: actorId,
                action: "UPDATE_EXTRA_FEE",
                roleSnapshot: userRole,
                targetId: extraFeeId,
                metadata: {found: extrafee}
            });
            return extrafee;
        } catch (error) {
            await this.logger.log({
                userId: actorId, 
                action: "UPDATE_EXTRA_FEE_FAILED",
                roleSnapshot: userRole, 
                targetId: extraFeeId,
                metadata: {error: (error as Error).message}
            });
        }
    }

    async deleteExtraFee(extraFeeId: string, actorId: string, userRole: string){
        try {
            const extrafee = await this.extraFeeRepository.delete(extraFeeId);
            await this.logger.log({
                userId: actorId,
                action: "DELETE_EXTRA_FEE",
                roleSnapshot: userRole,
                targetId: extraFeeId,
                metadata: {found: extrafee}
            });
            return extrafee;
        } catch (error) {
            await this.logger.log({
                userId: actorId, 
                action: "DELETE_EXTRA_FEE_FAILED",
                roleSnapshot: userRole, 
                targetId: extraFeeId,
                metadata: {error: (error as Error).message}
            });
        }
    }

}

export default ExtraFeeService;