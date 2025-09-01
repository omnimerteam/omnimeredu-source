import {Request, Response, NextFunction} from "express";
import { IExtraFee } from "../../../models";
import chalk from "chalk";
import { sendUnauthorized, sendSuccess, sendEmpty, sendNotFound } from "../../../../common/utils/ResponseHelper";
import ExtraFeeService from "../../../services/school/tuition/extraFee.service";

class ExtraFeeController{
    private readonly extraFeeService: ExtraFeeService;

    constructor(extraFeeService: ExtraFeeService){
        this.extraFeeService = extraFeeService;
    }

    async getAllExtraFee(req: Request, res: Response, next: NextFunction): Promise<void>{
        try {
            const actorId = req.user?.id;
            const userRole = req.role;
            const schoolId = req.user?.schoolId.toString();
            if(!actorId || !userRole){
                sendUnauthorized(res);
                return;
            }

            const extraFees = await this.extraFeeService.getAllExtraFees(actorId, schoolId, userRole);
            if(!extraFees){
                sendEmpty(res);
                return;
            }
            console.log(chalk.green("[Extra Fee] Getting all extra fees successfully"));
            sendSuccess(res, extraFees, "Lấy tất cả extra fees thành công");
        } catch (error) {
            console.log(chalk.red("[Extra Fee] Error getting all extra fees: ", error));
            return next(error);
        }
    }

    async getExtraFeeById(req: Request, res: Response, next: NextFunction): Promise<void>{
        try {
            const actorId = req.user?.id;
            const userRole = req.role;
            if(!actorId || !userRole){
                sendUnauthorized(res);
                return;
            }
            const extraFeeId = req.params.id;
            const extraFee = await this.extraFeeService.getExtraFeeById(extraFeeId, actorId, userRole);
            if(!extraFee){
                sendNotFound(res);
                return;
            }
            console.log(chalk.green("[Extra Fee] Getting extra fee by ID successfully"));
            sendSuccess(res, extraFee, "Lấy extra fee theo ID thành công");
        } catch (error) {
            console.log(chalk.red("[Extra Fee] Error getting extra fee by ID: ", error));
            return next(error);
        }
    }

    async createExtraFee(req: Request, res: Response, next: NextFunction): Promise<void>{
        try {
            const actorId = req.user?.id;
            const userRole = req.role;
            if(!actorId || !userRole){
                sendUnauthorized(res);
                return;
            }
            const extraFeeData: Partial<IExtraFee>= req.body;
            const extraFee = await this.extraFeeService.createExtraFee(extraFeeData, actorId, userRole);
            console.log(chalk.green("[Extra Fee] Creatting extra fee successfully"));
            sendSuccess(res, extraFee, "Thêm mới extra fee thành công");
        } catch (error) {
            console.log(chalk.red("[Extra Fee] Error creatting extra fee: ", error));
            return next(error);
        }
    }

    async updateExtraFee(req: Request, res: Response, next: NextFunction): Promise<void>{
        try {
            const actorId = req.user?.id;
            const userRole = req.role;
            if(!actorId || !userRole){
                sendUnauthorized(res);
                return;
            }
            const extraFeeData: Partial<IExtraFee>= req.body;
            const extraFeeId = req.params.id;
            const extraFee = await this.extraFeeService.updateExtraFee(extraFeeData, extraFeeId, actorId, userRole);
            console.log(chalk.green("[Extra Fee] Updatting extra fee successfully"));
            sendSuccess(res, extraFee, "Cập nhật extra fee thành công");
        } catch (error) {
            console.log(chalk.red("[Extra Fee] Error updatting extra fee: ", error));
            return next(error);
        }
    }

    async deleteExtraFee(req: Request, res: Response, next: NextFunction): Promise<void>{
        try {
            const actorId = req.user?.id;
            const userRole = req.role;
            if(!actorId || !userRole){
                sendUnauthorized(res);
                return;
            }
            const extraFeeId = req.params.id;
            const extraFee = await this.extraFeeService.deleteExtraFee(extraFeeId, actorId, userRole);
            console.log(chalk.green("[Extra Fee] Deletting extra fee successfully"));
            sendSuccess(res, extraFee, "Xóa extra fee thành công");
        } catch (error) {
            console.log(chalk.red("[Extra Fee] Error deletting extra fee: ", error));
            return next(error);
        }
    }
}

export default ExtraFeeController;