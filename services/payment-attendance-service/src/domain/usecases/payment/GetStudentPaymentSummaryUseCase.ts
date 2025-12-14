import {
  IPaymentReadRepository,
  PaymentSummary,
} from "../../repositories/IPaymentReadRepository";

export class GetStudentPaymentSummaryUseCase {
  constructor(private paymentReadRepo: IPaymentReadRepository) {}

  async execute(studentId: string): Promise<PaymentSummary> {
    // Validate input
    if (!studentId) {
      throw new Error("Student ID is required");
    }

    return this.paymentReadRepo.getStudentPaymentSummary(studentId);
  }
}
