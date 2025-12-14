/**
 * Read-side Repository Interface for Payment (MongoDB)
 * Used for optimized queries and payment history retrieval
 */

export interface PaymentHistoryItem {
  id: string;
  studentId: string;
  tuitionId: string;
  paymentMethodId: string;
  amount: number;
  transactionId: string;
  status: "Success" | "Failed";
  paidAt: Date;
  createdAt?: Date;
}

export interface PaymentHistoryFilter {
  studentId?: string;
  tuitionId?: string;
  status?: "Success" | "Failed";
  startDate?: Date;
  endDate?: Date;
}

export interface PaymentHistoryResult {
  items: PaymentHistoryItem[];
  total: number;
  page: number;
  limit: number;
  totalPages: number;
}

export interface PaymentSummary {
  totalAmount: number;
  successfulPayments: number;
  failedPayments: number;
  lastPaymentDate?: Date;
}

export interface IPaymentReadRepository {
  /**
   * Get paginated payment history with filters
   */
  getPaymentHistory(
    filter: PaymentHistoryFilter,
    page: number,
    limit: number
  ): Promise<PaymentHistoryResult>;

  /**
   * Get payment summary for a student
   */
  getStudentPaymentSummary(studentId: string): Promise<PaymentSummary>;

  /**
   * Get payments by date range for a school/class (for reports)
   */
  getPaymentsByDateRange(
    startDate: Date,
    endDate: Date,
    studentIds?: string[]
  ): Promise<PaymentHistoryItem[]>;
}
