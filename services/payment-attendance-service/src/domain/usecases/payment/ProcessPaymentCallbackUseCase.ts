import { IPaymentRepository } from "../../repositories/IPaymentRepository";
import { ITuitionRepository } from "../../repositories/ITuitionRepository";
import { PaymentCallbackDto } from "../../../presentation/dtos/PaymentDto";
import { Payment } from "../../entities/Payment";

export class ProcessPaymentCallbackUseCase {
    constructor(
        private paymentRepository: IPaymentRepository,
        private tuitionRepository: ITuitionRepository
    ) { }

    async execute(dto: PaymentCallbackDto): Promise<Payment> {
        const payment = await this.paymentRepository.findByTransactionId(dto.transactionId);
        if (!payment) {
            throw new Error("Payment not found for transaction ID: " + dto.transactionId);
        }

        // Update payment status
        payment.status = dto.status;
        if (dto.metadata) {
            payment.metadata = { ...payment.metadata, ...dto.metadata };
        }

        const updatedPayment = await this.paymentRepository.update(payment);

        // If payment is successful, update tuition
        if (updatedPayment.status === "Success") {
            const tuition = await this.tuitionRepository.findById(payment.tuitionId);
            if (tuition) {
                // Only update if not already paid to avoid double processing side effects if any
                if (tuition.status !== "Paid") {
                    tuition.status = "Paid";
                    tuition.paidAt = new Date();
                    tuition.invoiceId = payment.id;
                    await this.tuitionRepository.update(tuition);
                }
            }
        }

        return updatedPayment;
    }
}
