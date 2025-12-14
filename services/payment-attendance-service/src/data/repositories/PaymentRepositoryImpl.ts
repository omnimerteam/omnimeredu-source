import { IPaymentRepository } from "../../domain/repositories/IPaymentRepository";
import { Payment } from "../../domain/entities/Payment";
import { PaymentModel } from "../datasources/postgres/models/PaymentModel";

export class PaymentRepositoryImpl implements IPaymentRepository {
  async create(payment: Payment): Promise<Payment> {
    const model = await PaymentModel.create({
      studentId: payment.studentId,
      tuitionId: payment.tuitionId,
      paymentMethodId: payment.paymentMethodId,
      amount: payment.amount,
      transactionId: payment.transactionId,
      status: payment.status,
      paidAt: payment.paidAt,
    });
    return this.toEntity(model);
  }

  async findById(id: string): Promise<Payment | null> {
    const model = await PaymentModel.findByPk(id);
    if (!model) return null;
    return this.toEntity(model);
  }

  async findByTuitionId(tuitionId: string): Promise<Payment[]> {
    const models = await PaymentModel.findAll({
      where: { tuitionId },
      order: [["paidAt", "DESC"]],
    });
    return models.map((m) => this.toEntity(m));
  }

  async findByStudentId(studentId: string): Promise<Payment[]> {
    const models = await PaymentModel.findAll({
      where: { studentId },
      order: [["paidAt", "DESC"]],
    });
    return models.map((m) => this.toEntity(m));
  }

  async findByTransactionId(transactionId: string): Promise<Payment | null> {
    const model = await PaymentModel.findOne({
      where: { transactionId },
    });
    if (!model) return null;
    return this.toEntity(model);
  }

  async update(payment: Payment): Promise<Payment> {
    const [affectedCount, updatedModels] = await PaymentModel.update(
      {
        status: payment.status,
        amount: payment.amount,
      },
      {
        where: { id: payment.id },
        returning: true,
      }
    );

    if (affectedCount === 0 || !updatedModels[0]) {
      throw new Error("Payment not found or not updated");
    }

    return this.toEntity(updatedModels[0]);
  }

  async delete(id: string): Promise<boolean> {
    const deletedCount = await PaymentModel.destroy({ where: { id } });
    return deletedCount > 0;
  }

  private toEntity(model: PaymentModel): Payment {
    return new Payment(
      model.id,
      model.studentId,
      model.tuitionId,
      model.paymentMethodId,
      parseFloat(model.amount.toString()),
      model.transactionId,
      model.status,
      model.paidAt,
      model.createdAt,
      model.updatedAt
    );
  }
}
