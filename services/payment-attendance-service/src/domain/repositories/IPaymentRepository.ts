import { Payment } from "../entities/Payment";

export interface IPaymentRepository {
  create(payment: Payment): Promise<Payment>;
  findById(id: string): Promise<Payment | null>;
  findByTuitionId(tuitionId: string): Promise<Payment[]>;
  findByStudentId(studentId: string): Promise<Payment[]>;
  findByTransactionId(transactionId: string): Promise<Payment | null>;
  update(payment: Payment): Promise<Payment>;
  delete(id: string): Promise<boolean>;
}
