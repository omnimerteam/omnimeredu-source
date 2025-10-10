import {Request, Response, NextFunction} from "express";
import chalk from "chalk";
import { IHoliday } from "../../models/system/Holiday";
import HolidayService from "../../services/system/Holiday.service";
import { sendUnauthorized, sendEmpty, sendNotFound, sendSuccess } from "../../../common/utils/ResponseHelper";

class HolidayController{
    private readonly holidayService: HolidayService;
    constructor(holidayService: HolidayService){
        this.holidayService = holidayService;
    }

    async getAllHolidaies(req: Request, res: Response, next: NextFunction): Promise<void>{
        try {
            const actorId = req.user?.id;
            const userRole = req.role;
            if (!userRole || !actorId) {
                sendUnauthorized(res);
                return;
            }
            const holidaies = await this.holidayService.getAllHolidaies(actorId, userRole);
            if(!holidaies){
                sendEmpty(res);
                return;
            }
            console.log(chalk.green("[Holiday] Getting all holidaies successfully"));
            sendSuccess(res, holidaies, "Lấy tất cả lịch nghỉ thành công");
        } catch (error) {
            console.log(chalk.red("[Holiday] Error getting all holidaies:", error));
            return next(error);
        }
    }

    async getHolidayById(req: Request, res: Response, next: NextFunction): Promise<void>{
        try {
            const actorId = req.user?.id;
            const userRole = req.role;
            const id = req.params.id;
            if (!userRole || !actorId) {
                sendUnauthorized(res);
                return;
            }
            
            const holidaies = await this.holidayService.getHolidayById(id, actorId, userRole);
           
            if(!holidaies){
                sendNotFound(res);
                return;
            }
            console.log(chalk.green("[Holiday] Getting the holiday by ID successfully"));
            sendSuccess(res, holidaies, "Lấy lịch nghỉ theo ID thành công");
        } catch (error) {
            console.log(chalk.red("[Holiday] Error getting the holiday by ID:", error));
            return next(error);
        }
    }

    async createHoliday(req: Request, res: Response, next: NextFunction): Promise<void>{
        try {
            const actorId = req.user?.id;
            const userRole = req.role;
            if (!userRole || !actorId) {
                sendUnauthorized(res);
                return;
            }

            const data: Partial<IHoliday> = req.body;
            
            const holiday = await this.holidayService.createHoliday(data, actorId, userRole);
           
            console.log(chalk.green("[Holiday] Creatting the holiday successfully"));
            sendSuccess(res, holiday, "Thêm mới lịch nghỉ thành công");
        } catch (error) {
            console.log(chalk.red("[Holiday] Error creatting the holiday:", error));
            return next(error);
        }
    }

    async updateHoliday(req: Request, res: Response, next: NextFunction): Promise<void>{
        try {
            const actorId = req.user?.id;
            const userRole = req.role;
            if (!userRole || !actorId) {
                sendUnauthorized(res);
                return;
            }
            const id = req.params.id;
            const data: Partial<IHoliday> = req.body;
            
            const holiday = await this.holidayService.updateHoliday(id, data, actorId, userRole);
            
            if(!holiday){
                sendNotFound(res);
                return;
            }

            console.log(chalk.green("[Holiday] Updatting the holiday successfully"));
            sendSuccess(res, holiday, "Cập nhật lịch nghỉ thành công");
        } catch (error) {
            console.log(chalk.red("[Holiday] Error updatting the holiday:", error));
            return next(error);
        }
    }


    async deleteHoliday(req: Request, res: Response, next: NextFunction): Promise<void>{
        try {
            const actorId = req.user?.id;
            const userRole = req.role;
            if (!userRole || !actorId) {
                sendUnauthorized(res);
                return;
            }
            const id = req.params.id;            
            const holiday = await this.holidayService.deleteHoliday(id, actorId, userRole);

            console.log(chalk.green("[Holiday] Deletting the holiday successfully"));
            sendSuccess(res, holiday, "Xóa lịch nghỉ thành công");
        } catch (error) {
            console.log(chalk.red("[Holiday] Error deletting the holiday:", error));
            return next(error);
        }
    }
}

export default HolidayController;