import { IPaymentRepository } from "../../repositories/IPaymentRepository";
import { ITuitionRepository } from "../../repositories/ITuitionRepository";
import { CreatePaymentDto } from "../../../presentation/dtos/PaymentDto";
import { Payment } from "../../entities/Payment";

export class CreatePaymentUseCase {
  constructor(
    private paymentRepository: IPaymentRepository,
    private tuitionRepository: ITuitionRepository
  ) {}

  async execute(dto: CreatePaymentDto): Promise<Payment> {
    // Check if transaction already exists
    const existingPayment = await this.paymentRepository.findByTransactionId(
      dto.transactionId
    );

    if (existingPayment) {
      throw new Error("Payment with this transaction ID already exists");
    }

    // Verify tuition exists
    const tuition = await this.tuitionRepository.findById(dto.tuitionId);
    if (!tuition) {
      throw new Error("Tuition not found");
    }

    // Create payment
    const payment = new Payment(
      "", // ID will be generated
      dto.studentId,
      dto.tuitionId,
      dto.paymentMethodId,
      dto.amount,
      dto.transactionId,
      dto.status,
      dto.paidAt
    );

    const createdPayment = await this.paymentRepository.create(payment);

    // Update tuition status if payment is successful
    if (dto.status === "Success") {
      tuition.status = "Paid";
      tuition.paidAt = dto.paidAt;
      tuition.invoiceId = createdPayment.id;
      await this.tuitionRepository.update(tuition);
    }

    return createdPayment;
  }
}
