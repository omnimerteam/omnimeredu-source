import {
  IPaymentReadRepository,
  PaymentHistoryFilter,
  PaymentHistoryResult,
  PaymentHistoryItem,
  PaymentSummary,
} from "../../domain/repositories/IPaymentReadRepository";
import { PaymentReadModel } from "../datasources/mongodb/schemas/PaymentReadSchema";

interface PaymentDoc {
  _id: string;
  studentId: string;
  tuitionId: string;
  paymentMethodId: string;
  amount: number;
  transactionId: string;
  status: "Success" | "Failed";
  paidAt: Date;
  createdAt?: Date;
}

interface QueryFilter {
  studentId?: string;
  tuitionId?: string;
  status?: "Success" | "Failed";
  paidAt?: {
    $gte?: Date;
    $lte?: Date;
  };
}

export class PaymentReadRepositoryImpl implements IPaymentReadRepository {
  /**
   * Get paginated payment history with filters
   */
  async getPaymentHistory(
    filter: PaymentHistoryFilter,
    page: number = 1,
    limit: number = 20
  ): Promise<PaymentHistoryResult> {
    const query: QueryFilter = {};

    if (filter.studentId) {
      query.studentId = filter.studentId;
    }
    if (filter.tuitionId) {
      query.tuitionId = filter.tuitionId;
    }
    if (filter.status) {
      query.status = filter.status;
    }
    if (filter.startDate || filter.endDate) {
      query.paidAt = {};
      if (filter.startDate) {
        query.paidAt.$gte = filter.startDate;
      }
      if (filter.endDate) {
        query.paidAt.$lte = filter.endDate;
      }
    }

    const skip = (page - 1) * limit;

    const [items, total] = await Promise.all([
      PaymentReadModel.find(query)
        .sort({ paidAt: -1 })
        .skip(skip)
        .limit(limit)
        .lean() as Promise<PaymentDoc[]>,
      PaymentReadModel.countDocuments(query),
    ]);

    const totalPages = Math.ceil(total / limit);

    return {
      items: items.map((item: PaymentDoc) =>
        this.mapToPaymentHistoryItem(item)
      ),
      total,
      page,
      limit,
      totalPages,
    };
  }

  /**
   * Get payment summary for a student
   */
  async getStudentPaymentSummary(studentId: string): Promise<PaymentSummary> {
    const aggregation = await PaymentReadModel.aggregate([
      { $match: { studentId } },
      {
        $group: {
          _id: null,
          totalAmount: {
            $sum: { $cond: [{ $eq: ["$status", "Success"] }, "$amount", 0] },
          },
          successfulPayments: {
            $sum: { $cond: [{ $eq: ["$status", "Success"] }, 1, 0] },
          },
          failedPayments: {
            $sum: { $cond: [{ $eq: ["$status", "Failed"] }, 1, 0] },
          },
          lastPaymentDate: { $max: "$paidAt" },
        },
      },
    ]);

    if (aggregation.length === 0) {
      return {
        totalAmount: 0,
        successfulPayments: 0,
        failedPayments: 0,
        lastPaymentDate: undefined,
      };
    }

    return {
      totalAmount: aggregation[0].totalAmount,
      successfulPayments: aggregation[0].successfulPayments,
      failedPayments: aggregation[0].failedPayments,
      lastPaymentDate: aggregation[0].lastPaymentDate,
    };
  }

  /**
   * Get payments by date range for students (for reports)
   */
  async getPaymentsByDateRange(
    startDate: Date,
    endDate: Date,
    studentIds?: string[]
  ): Promise<PaymentHistoryItem[]> {
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    const query: Record<string, any> = {
      paidAt: { $gte: startDate, $lte: endDate },
    };

    if (studentIds && studentIds.length > 0) {
      query.studentId = { $in: studentIds };
    }

    const payments = (await PaymentReadModel.find(query)
      .sort({ paidAt: -1 })
      .lean()) as PaymentDoc[];

    return payments.map((item: PaymentDoc) =>
      this.mapToPaymentHistoryItem(item)
    );
  }

  /**
   * Map MongoDB document to PaymentHistoryItem
   */
  private mapToPaymentHistoryItem(doc: PaymentDoc): PaymentHistoryItem {
    return {
      id: doc._id,
      studentId: doc.studentId,
      tuitionId: doc.tuitionId,
      paymentMethodId: doc.paymentMethodId,
      amount: doc.amount,
      transactionId: doc.transactionId,
      status: doc.status,
      paidAt: doc.paidAt,
      createdAt: doc.createdAt,
    };
  }
}
