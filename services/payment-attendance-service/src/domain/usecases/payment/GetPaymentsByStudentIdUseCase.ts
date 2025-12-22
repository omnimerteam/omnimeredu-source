import { IPaymentRepository } from "../../repositories/IPaymentRepository";
import { Payment } from "../../entities/Payment";

export class GetPaymentsByStudentIdUseCase {
    constructor(private paymentRepository: IPaymentRepository) { }

    async execute(studentId: string): Promise<Payment[]> {
        return await this.paymentRepository.findByStudentId(studentId);
    }
}
