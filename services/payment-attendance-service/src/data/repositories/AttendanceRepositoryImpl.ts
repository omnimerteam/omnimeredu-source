import { IAttendanceRepository } from "../../domain/repositories/IAttendanceRepository";
import { Attendance } from "../../domain/entities/Attendance";
import { AttendanceModel } from "../datasources/postgres/models/AttendanceModel";
import { Op } from "sequelize";

export class AttendanceRepositoryImpl implements IAttendanceRepository {
  async create(attendance: Attendance): Promise<Attendance> {
    const model = await AttendanceModel.create({
      classId: attendance.classId,
      schoolId: attendance.schoolId,
      date: attendance.date,
      sessionType: attendance.sessionType,
    });
    return this.toEntity(model);
  }

  async findById(id: string): Promise<Attendance | null> {
    const model = await AttendanceModel.findByPk(id);
    if (!model) return null;
    return this.toEntity(model);
  }

  async findByClassAndDate(
    classId: string,
    date: Date
  ): Promise<Attendance | null> {
    const model = await AttendanceModel.findOne({
      where: {
        classId,
        date,
      },
    });
    if (!model) return null;
    return this.toEntity(model);
  }

  async findBySchoolAndDateRange(
    schoolId: string,
    startDate: Date,
    endDate: Date
  ): Promise<Attendance[]> {
    const models = await AttendanceModel.findAll({
      where: {
        schoolId,
        date: {
          [Op.between]: [startDate, endDate],
        },
      },
      order: [["date", "DESC"]],
    });
    return models.map((m) => this.toEntity(m));
  }

  async update(attendance: Attendance): Promise<Attendance> {
    const [affectedCount, updatedModels] = await AttendanceModel.update(
      {
        sessionType: attendance.sessionType,
        date: attendance.date,
      },
      {
        where: { id: attendance.id },
        returning: true,
      }
    );

    if (affectedCount === 0 || !updatedModels[0]) {
      throw new Error("Attendance not found or not updated");
    }

    return this.toEntity(updatedModels[0]);
  }

  async delete(id: string): Promise<boolean> {
    const deletedCount = await AttendanceModel.destroy({ where: { id } });
    return deletedCount > 0;
  }

  private toEntity(model: AttendanceModel): Attendance {
    return new Attendance(
      model.id,
      model.classId,
      model.schoolId,
      model.date,
      model.sessionType,
      model.createdAt,
      model.updatedAt
    );
  }
}
