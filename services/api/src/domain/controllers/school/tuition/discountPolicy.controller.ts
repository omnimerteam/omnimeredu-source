import {Request, Response, NextFunction} from "express";
import chalk from "chalk";
import {
  sendSuccess,
  sendCreated,
  sendNotFound,
  sendEmpty,
  sendUnauthorized,
} from "../../../../common/utils/ResponseHelper";
import { IDiscountPolicy } from "../../../models";
import DiscountPolicyService from "../../../services/school/tuition/dicountPolicy.service";


class DiscountPolicyController{
    private readonly discountPolicyService: DiscountPolicyService;
    constructor(discountPolicyService: DiscountPolicyService){
        this.discountPolicyService = discountPolicyService;
    }

    async getAllDiscountPolicy(req: Request, res: Response, next: NextFunction): Promise<void>{
        try {
            const actorId = req.user?.id;
            const userRole = req.role;
            const schoolId = req.user?.schoolId?.toString();
            if(!actorId || !userRole){
                sendUnauthorized(res);
                return;
            }
            const discountPolicies = await this.discountPolicyService.getAllDisCountPolicy(actorId, schoolId, userRole);
            if(!discountPolicies || discountPolicies.length === 0){
                sendEmpty(res);
                return;
            }
            console.log(chalk.green("[Discount Policy Getting all discount policies successfully"));
            sendSuccess(res, discountPolicies, "Lấy tất cả discount policies thành công ");

        } catch (error){
            console.log(chalk.red("[Discount Policy] Error getting all discount policies: ", error))
            return next(error);
        }
    }

    async getDiscountPolicyById(req: Request, res: Response, next: NextFunction): Promise<void>{
        try {
            const actorId = req.user?.id;
            const userRole = req.role;
            if(!actorId || !userRole){
                sendUnauthorized(res);
                return;
            }
            const discountPolicyId = req.params.id;
            const discountPolicy = await this.discountPolicyService.getDisCountPolicyById(discountPolicyId, actorId, userRole);
            if(!discountPolicy){
                sendNotFound(res);
                return;
            }
            console.log(chalk.green("[Discount Policy] Getting discount policy by ID successfully"));
            sendSuccess(res, discountPolicy, "Lấy discount policy bằng ID thành công ");

        } catch (error){
            console.log(chalk.red("[Discount Policy] Error getting discount policy by ID: ", error))
            return next(error);
        }
    }

    async createDiscountPolicy(req: Request, res: Response, next: NextFunction): Promise<void>{
        try {
            const actorId = req.user?.id;
            const userRole = req.role;
            if(!actorId || !userRole){
                sendUnauthorized(res);
                return;
            }
            const discountPolicyData: Partial<IDiscountPolicy> = req.body;
            const discountPolicy = await this.discountPolicyService.createDisCountPolicy(discountPolicyData, actorId, userRole);
            console.log(chalk.green("[Discount Policy] Creatting discount policy successfully]"));
            sendSuccess(res, discountPolicy, "Thêm mới discount policy thành công ");

        } catch (error){
            console.log(chalk.red("[Discount Policy] Error creatting discount policy: ", error))
            return next(error);
        }
    }

    async updateDiscountPolicy(req: Request, res: Response, next: NextFunction): Promise<void>{
        try {
            const actorId = req.user?.id;
            const userRole = req.role;
            if(!actorId || !userRole){
                sendUnauthorized(res);
                return;
            }
            const discountPolicyData: Partial<IDiscountPolicy> = req.body;
            const discountPolicyId = req.params.id;
            const discountPolicy = await this.discountPolicyService.updateDisCountPolicy(discountPolicyData, discountPolicyId, actorId, userRole);
            console.log(chalk.green("[Discount Policy] Updatting discount policy successfully"));
            sendSuccess(res, discountPolicy, "Cập nhật discount policy thành công ");

        } catch (error){
            console.log(chalk.red("[Discount Policy] Error updatting discount policy: ", error))
            return next(error);
        }
    }

    async deleteDiscountPolicy(req: Request, res: Response, next: NextFunction): Promise<void>{
        try {
            const actorId = req.user?.id;
            const userRole = req.role;
            if(!actorId || !userRole){
                sendUnauthorized(res);
                return;
            }
            const discountPolicyId = req.params.id;
            const discountPolicy = await this.discountPolicyService.deleteDisCountPolicy(discountPolicyId, actorId, userRole);
            console.log(chalk.green("[Discount Policy] Deletting discount policy successfully"));
            sendSuccess(res, discountPolicy, "Xóa discount policy thành công ");

        } catch (error){
            console.log(chalk.red("[Discount Policy] Error deletting discount policy: ", error))
            return next(error);
        }
    }
}

export default DiscountPolicyController;