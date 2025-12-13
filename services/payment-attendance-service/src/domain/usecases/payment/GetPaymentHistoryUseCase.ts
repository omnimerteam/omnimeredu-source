import {
  IPaymentReadRepository,
  PaymentHistoryFilter,
  PaymentHistoryResult,
} from "../../repositories/IPaymentReadRepository";

export class GetPaymentHistoryUseCase {
  constructor(private paymentReadRepo: IPaymentReadRepository) {}

  async execute(
    filter: PaymentHistoryFilter,
    page: number = 1,
    limit: number = 20
  ): Promise<PaymentHistoryResult> {
    // Validate pagination
    if (page < 1) {
      throw new Error("Page must be at least 1");
    }

    if (limit < 1 || limit > 100) {
      throw new Error("Limit must be between 1 and 100");
    }

    // Validate date range if provided
    if (filter.startDate && filter.endDate) {
      if (filter.startDate > filter.endDate) {
        throw new Error("Start date must be before or equal to end date");
      }
    }

    return this.paymentReadRepo.getPaymentHistory(filter, page, limit);
  }
}
