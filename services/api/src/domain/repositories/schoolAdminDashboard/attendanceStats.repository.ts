// repositories/attendanceStats.repository.ts
import { Model, Types } from "mongoose";
import { IDetailsRecord } from "../../models";
import { DateUtils } from "../../../common/utils/DateUtils";

class AttendanceStatsRepository {
  private readonly detailsRecordModel: Model<IDetailsRecord>;

  constructor(detailsRecordModel: Model<IDetailsRecord>) {
    this.detailsRecordModel = detailsRecordModel;
  }

  /**
   * Lấy thống kê điểm danh cho 1 trường trong ngày
   * @param schoolId id của trường
   * @param date ngày cần lấy thống kê
   */
  async getAttendanceStatsBySchool(schoolId: string, date?: Date) {
    const match: any = { "attendance.schoolId": new Types.ObjectId(schoolId) };

    // luôn mặc định là hôm nay (theo VN) nếu không truyền date
    const targetDate = date ?? new Date();
    console.log("Ngày hôm nay UTC + 7:", targetDate);

    // VN = UTC+7, cần convert sang UTC để query trên Mongo Atlas
    const { start, end } = DateUtils.getUtcDayRange(targetDate);
    console.log(`Ngày hôm nay UTC + 0: ${start} - ${end}`);

    match["attendance.date"] = { $gte: start, $lte: end };

    return this.detailsRecordModel.aggregate([
      {
        $lookup: {
          from: "attendances",
          let: { attendanceId: "$attendanceId" },
          pipeline: [
            { $match: { $expr: { $eq: ["$_id", "$$attendanceId"] } } },
            { $project: { classId: 1, schoolId: 1, date: 1 } },
          ],
          as: "attendance",
        },
      },
      { $unwind: "$attendance" },
      { $match: match },
      {
        $lookup: {
          from: "classes",
          let: { classId: "$attendance.classId" },
          pipeline: [
            { $match: { $expr: { $eq: ["$_id", "$$classId"] } } },
            { $project: { name: 1 } },
          ],
          as: "class",
        },
      },
      { $unwind: "$class" },
      {
        $group: {
          _id: "$attendance.classId",
          className: { $first: "$class.name" },
          total: { $sum: 1 },
          presentCount: {
            $sum: { $cond: [{ $eq: ["$status", "Present"] }, 1, 0] },
          },
        },
      },
      {
        $project: {
          _id: 0,
          className: 1,
          classAttendanceRate: {
            $cond: [
              { $eq: ["$total", 0] },
              0,
              { $divide: ["$presentCount", "$total"] },
            ],
          },
        },
      },
    ]);
  }
}

export default AttendanceStatsRepository;
