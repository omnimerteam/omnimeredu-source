import { IAttendanceRecordRepository } from "../../domain/repositories/IAttendanceRecordRepository";
import { AttendanceRecord } from "../../domain/entities/AttendanceRecord";
import { AttendanceRecordModel } from "../datasources/postgres/models/AttendanceRecordModel";
import { AttendanceModel } from "../datasources/postgres/models/AttendanceModel";
import { Op } from "sequelize";

export class AttendanceRecordRepositoryImpl
  implements IAttendanceRecordRepository
{
  async create(record: AttendanceRecord): Promise<AttendanceRecord> {
    const model = await AttendanceRecordModel.create({
      studentId: record.studentId,
      attendanceId: record.attendanceId,
      status: record.status,
      note: record.note,
    });
    return this.toEntity(model);
  }

  async createBulk(records: AttendanceRecord[]): Promise<AttendanceRecord[]> {
    const models = await AttendanceRecordModel.bulkCreate(
      records.map((r) => ({
        studentId: r.studentId,
        attendanceId: r.attendanceId,
        status: r.status,
        note: r.note,
      }))
    );
    return models.map((m) => this.toEntity(m));
  }

  async findById(id: string): Promise<AttendanceRecord | null> {
    const model = await AttendanceRecordModel.findByPk(id);
    if (!model) return null;
    return this.toEntity(model);
  }

  async findByAttendanceId(attendanceId: string): Promise<AttendanceRecord[]> {
    const models = await AttendanceRecordModel.findAll({
      where: { attendanceId },
      order: [["createdAt", "ASC"]],
    });
    return models.map((m) => this.toEntity(m));
  }

  async findByStudentAndDateRange(
    studentId: string,
    startDate: Date,
    endDate: Date
  ): Promise<AttendanceRecord[]> {
    const models = await AttendanceRecordModel.findAll({
      where: { studentId },
      include: [
        {
          model: AttendanceModel,
          as: "attendance",
          where: {
            date: {
              [Op.between]: [startDate, endDate],
            },
          },
          required: true,
        },
      ],
      order: [[{ model: AttendanceModel, as: "attendance" }, "date", "DESC"]],
    });
    return models.map((m) => this.toEntity(m));
  }

  async update(record: AttendanceRecord): Promise<AttendanceRecord> {
    const [affectedCount, updatedModels] = await AttendanceRecordModel.update(
      {
        status: record.status,
        note: record.note,
      },
      {
        where: { id: record.id },
        returning: true,
      }
    );

    if (affectedCount === 0 || !updatedModels[0]) {
      throw new Error("Attendance record not found or not updated");
    }

    return this.toEntity(updatedModels[0]);
  }

  async delete(id: string): Promise<boolean> {
    const deletedCount = await AttendanceRecordModel.destroy({ where: { id } });
    return deletedCount > 0;
  }

  private toEntity(model: AttendanceRecordModel): AttendanceRecord {
    return new AttendanceRecord(
      model.id,
      model.studentId,
      model.attendanceId,
      model.status,
      model.note,
      model.createdAt,
      model.updatedAt
    );
  }
}
