import { Request, Response } from "express";
import { CreateTuitionUseCase } from "../../domain/usecases/tuition/CreateTuitionUseCase";
import { GetTuitionByIdUseCase } from "../../domain/usecases/tuition/GetTuitionByIdUseCase";
import { GetTuitionsByPeriodUseCase } from "../../domain/usecases/tuition/GetTuitionsByPeriodUseCase";
import { ConfirmTuitionUseCase } from "../../domain/usecases/tuition/ConfirmTuitionUseCase";
import { CreateTuitionDto, ConfirmTuitionDto } from "../dtos/TuitionDto";

export class TuitionController {
    constructor(
        private createTuitionUseCase: CreateTuitionUseCase,
        private getTuitionByIdUseCase: GetTuitionByIdUseCase,
        private getTuitionsByPeriodUseCase: GetTuitionsByPeriodUseCase,
        private confirmTuitionUseCase: ConfirmTuitionUseCase
    ) { }

    async create(req: Request, res: Response): Promise<void> {
        try {
            const dto: CreateTuitionDto = req.body;
            const result = await this.createTuitionUseCase.execute(dto);
            res.status(201).json(result);
        } catch (error: any) {
            res.status(400).json({ error: error.message });
        }
    }

    async getById(req: Request, res: Response): Promise<void> {
        try {
            const id = req.params.id;
            const result = await this.getTuitionByIdUseCase.execute(id);
            if (!result) {
                res.status(404).json({ error: "Tuition not found" });
                return;
            }
            res.status(200).json(result);
        } catch (error: any) {
            res.status(400).json({ error: error.message });
        }
    }

    async getByPeriod(req: Request, res: Response): Promise<void> {
        try {
            const { schoolId, start, end } = req.query;
            if (!schoolId || !start || !end) {
                res.status(400).json({ error: "Missing required query parameters: schoolId, start, end" });
                return;
            }
            const result = await this.getTuitionsByPeriodUseCase.execute(
                schoolId as string,
                new Date(start as string),
                new Date(end as string)
            );
            res.status(200).json(result);
        } catch (error: any) {
            res.status(400).json({ error: error.message });
        }
    }

    async confirm(req: Request, res: Response): Promise<void> {
        try {
            const id = req.params.id;
            const dto: ConfirmTuitionDto = req.body;
            const result = await this.confirmTuitionUseCase.execute(id, dto);
            res.status(200).json(result);
        } catch (error: any) {
            res.status(400).json({ error: error.message });
        }
    }
}
