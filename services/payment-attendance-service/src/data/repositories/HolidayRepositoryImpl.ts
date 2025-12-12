import { IHolidayRepository } from "../../domain/repositories/IHolidayRepository";
import { Holiday } from "../../domain/entities/Holiday";
import { HolidayModel } from "../datasources/postgres/models/HolidayModel";
import { Op } from "sequelize";

export class HolidayRepositoryImpl implements IHolidayRepository {
  async create(holiday: Holiday): Promise<Holiday> {
    const model = await HolidayModel.create({
      schoolId: holiday.schoolId,
      name: holiday.name,
      date: holiday.date,
      isRecurring: holiday.isRecurring,
      type: holiday.type,
    });
    return this.toEntity(model);
  }

  async findById(id: string): Promise<Holiday | null> {
    const model = await HolidayModel.findByPk(id);
    if (!model) return null;
    return this.toEntity(model);
  }

  async findByDate(date: Date, schoolId?: string): Promise<Holiday[]> {
    const where: any = { date };
    if (schoolId) {
      where[Op.or] = [{ schoolId }, { type: "national" }];
    } else {
      where.type = "national";
    }

    const models = await HolidayModel.findAll({ where });
    return models.map((m) => this.toEntity(m));
  }

  async findByDateRange(
    startDate: Date,
    endDate: Date,
    schoolId?: string
  ): Promise<Holiday[]> {
    const where: any = {
      date: {
        [Op.between]: [startDate, endDate],
      },
    };

    if (schoolId) {
      where[Op.or] = [{ schoolId }, { type: "national" }];
    } else {
      where.type = "national";
    }

    const models = await HolidayModel.findAll({
      where,
      order: [["date", "ASC"]],
    });
    return models.map((m) => this.toEntity(m));
  }

  async findByType(
    type: "national" | "school",
    schoolId?: string
  ): Promise<Holiday[]> {
    const where: any = { type };
    if (type === "school" && schoolId) {
      where.schoolId = schoolId;
    }

    const models = await HolidayModel.findAll({
      where,
      order: [["date", "ASC"]],
    });
    return models.map((m) => this.toEntity(m));
  }

  async update(holiday: Holiday): Promise<Holiday> {
    const [affectedCount, updatedModels] = await HolidayModel.update(
      {
        name: holiday.name,
        date: holiday.date,
        isRecurring: holiday.isRecurring,
        type: holiday.type,
      },
      {
        where: { id: holiday.id },
        returning: true,
      }
    );

    if (affectedCount === 0 || !updatedModels[0]) {
      throw new Error("Holiday not found or not updated");
    }

    return this.toEntity(updatedModels[0]);
  }

  async delete(id: string): Promise<boolean> {
    const deletedCount = await HolidayModel.destroy({ where: { id } });
    return deletedCount > 0;
  }

  private toEntity(model: HolidayModel): Holiday {
    return new Holiday(
      model.id,
      model.name,
      model.date,
      model.isRecurring,
      model.type,
      model.schoolId,
      model.createdAt,
      model.updatedAt
    );
  }
}
