import { Request, Response } from "express";
import { CreatePaymentUseCase } from "../../domain/usecases/payment/CreatePaymentUseCase";
import { GetPaymentsByStudentIdUseCase } from "../../domain/usecases/payment/GetPaymentsByStudentIdUseCase";
import { ProcessPaymentCallbackUseCase } from "../../domain/usecases/payment/ProcessPaymentCallbackUseCase";
import { CreatePaymentDto, PaymentCallbackDto } from "../dtos/PaymentDto";

export class PaymentController {
    constructor(
        private createPaymentUseCase: CreatePaymentUseCase,
        private getPaymentsByStudentIdUseCase: GetPaymentsByStudentIdUseCase,
        private processPaymentCallbackUseCase: ProcessPaymentCallbackUseCase
    ) { }

    async create(req: Request, res: Response): Promise<void> {
        try {
            const dto: CreatePaymentDto = req.body;
            const result = await this.createPaymentUseCase.execute(dto);
            res.status(201).json(result);
        } catch (error: any) {
            res.status(400).json({ error: error.message });
        }
    }

    async getByStudent(req: Request, res: Response): Promise<void> {
        try {
            const studentId = req.params.studentId;
            const result = await this.getPaymentsByStudentIdUseCase.execute(studentId);
            res.status(200).json(result);
        } catch (error: any) {
            res.status(400).json({ error: error.message });
        }
    }

    async callback(req: Request, res: Response): Promise<void> {
        try {
            const dto: PaymentCallbackDto = req.body;
            const result = await this.processPaymentCallbackUseCase.execute(dto);
            res.status(200).json(result);
        } catch (error: any) {
            res.status(400).json({ error: error.message });
        }
    }
}
