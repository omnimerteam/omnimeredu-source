import { Request, Response } from "express";
import { CreateHolidayUseCase } from "../../domain/usecases/holiday/CreateHolidayUseCase";
import { GetHolidaysByDateRangeUseCase } from "../../domain/usecases/holiday/GetHolidaysByDateRangeUseCase";
import { CheckIsHolidayUseCase } from "../../domain/usecases/holiday/CheckIsHolidayUseCase";
import { CreateHolidayDto } from "../dtos/HolidayDto";

export class HolidayController {
    constructor(
        private createHolidayUseCase: CreateHolidayUseCase,
        private getHolidaysByDateRangeUseCase: GetHolidaysByDateRangeUseCase,
        private checkIsHolidayUseCase: CheckIsHolidayUseCase
    ) { }

    async create(req: Request, res: Response): Promise<void> {
        try {
            const dto: CreateHolidayDto = req.body;
            const result = await this.createHolidayUseCase.execute(dto);
            res.status(201).json(result);
        } catch (error: any) {
            res.status(400).json({ error: error.message });
        }
    }

    async getByDateRange(req: Request, res: Response): Promise<void> {
        try {
            const { start, end, schoolId } = req.query;
            if (!start || !end) {
                res.status(400).json({ error: "Missing required query parameters: start, end" });
                return;
            }
            const result = await this.getHolidaysByDateRangeUseCase.execute(
                new Date(start as string),
                new Date(end as string),
                schoolId as string
            );
            res.status(200).json(result);
        } catch (error: any) {
            res.status(400).json({ error: error.message });
        }
    }

    async checkIsHoliday(req: Request, res: Response): Promise<void> {
        try {
            const { date, schoolId } = req.query;
            if (!date) {
                res.status(400).json({ error: "Missing required query parameter: date" });
                return;
            }
            const result = await this.checkIsHolidayUseCase.execute(
                new Date(date as string),
                schoolId as string
            );
            res.status(200).json({ isHoliday: result });
        } catch (error: any) {
            res.status(400).json({ error: error.message });
        }
    }
}
