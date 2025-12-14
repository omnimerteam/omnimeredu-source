import { ITuitionRepository } from "../../domain/repositories/ITuitionRepository";
import { Tuition } from "../../domain/entities/Tuition";
import { TuitionModel } from "../datasources/postgres/models/TuitionModel";
import { Op } from "sequelize";

export class TuitionRepositoryImpl implements ITuitionRepository {
  async create(tuition: Tuition): Promise<Tuition> {
    const model = await TuitionModel.create({
      studentId: tuition.studentId,
      schoolId: tuition.schoolId,
      classId: tuition.classId,
      month: tuition.month,
      periodStart: tuition.periodStart,
      periodEnd: tuition.periodEnd,
      baseFeeSnapshot: tuition.baseFeeSnapshot,
      extraFeeDetails: tuition.extraFeeDetails,
      discountDetails: tuition.discountDetails,
      appliedRules: tuition.appliedRules,
      calculationLog: tuition.calculationLog,
      totalAmount: tuition.totalAmount,
      attendedDays: tuition.attendedDays,
      currency: tuition.currency,
      status: tuition.status,
      createdBy: tuition.createdBy,
      confirmedBy: tuition.confirmedBy,
      confirmedAt: tuition.confirmedAt,
      paidAt: tuition.paidAt,
      invoiceId: tuition.invoiceId,
      dueDate: tuition.dueDate,
      meta: tuition.meta,
    });
    return this.toEntity(model);
  }

  async findById(id: string): Promise<Tuition | null> {
    const model = await TuitionModel.findByPk(id);
    if (!model) return null;
    return this.toEntity(model);
  }

  async findByStudentAndPeriod(
    studentId: string,
    periodStart: Date
  ): Promise<Tuition | null> {
    const model = await TuitionModel.findOne({
      where: {
        studentId,
        periodStart,
      },
    });
    if (!model) return null;
    return this.toEntity(model);
  }

  async findBySchoolAndPeriod(
    schoolId: string,
    periodStart: Date,
    periodEnd: Date
  ): Promise<Tuition[]> {
    const models = await TuitionModel.findAll({
      where: {
        schoolId,
        periodStart: {
          [Op.gte]: periodStart,
        },
        periodEnd: {
          [Op.lte]: periodEnd,
        },
      },
      order: [["periodStart", "DESC"]],
    });
    return models.map((m) => this.toEntity(m));
  }

  async findByStatus(status: string): Promise<Tuition[]> {
    const models = await TuitionModel.findAll({
      where: { status },
      order: [["createdAt", "DESC"]],
    });
    return models.map((m) => this.toEntity(m));
  }

  async update(tuition: Tuition): Promise<Tuition> {
    const [affectedCount, updatedModels] = await TuitionModel.update(
      {
        baseFeeSnapshot: tuition.baseFeeSnapshot,
        extraFeeDetails: tuition.extraFeeDetails,
        discountDetails: tuition.discountDetails,
        appliedRules: tuition.appliedRules,
        calculationLog: tuition.calculationLog,
        totalAmount: tuition.totalAmount,
        attendedDays: tuition.attendedDays,
        status: tuition.status,
        confirmedBy: tuition.confirmedBy,
        confirmedAt: tuition.confirmedAt,
        paidAt: tuition.paidAt,
        invoiceId: tuition.invoiceId,
        dueDate: tuition.dueDate,
        meta: tuition.meta,
      },
      {
        where: { id: tuition.id },
        returning: true,
      }
    );

    if (affectedCount === 0 || !updatedModels[0]) {
      throw new Error("Tuition not found or not updated");
    }

    return this.toEntity(updatedModels[0]);
  }

  async delete(id: string): Promise<boolean> {
    const deletedCount = await TuitionModel.destroy({ where: { id } });
    return deletedCount > 0;
  }

  private toEntity(model: TuitionModel): Tuition {
    return new Tuition(
      model.id,
      model.studentId,
      model.schoolId,
      model.classId,
      parseFloat(model.baseFeeSnapshot.toString()),
      parseFloat(model.totalAmount.toString()),
      model.attendedDays,
      model.status,
      model.currency,
      model.periodStart,
      model.periodEnd,
      model.month,
      model.extraFeeDetails,
      model.discountDetails,
      model.appliedRules,
      model.calculationLog,
      model.createdBy,
      model.confirmedBy,
      model.confirmedAt,
      model.paidAt,
      model.invoiceId,
      model.dueDate,
      model.meta,
      model.createdAt,
      model.updatedAt
    );
  }
}
