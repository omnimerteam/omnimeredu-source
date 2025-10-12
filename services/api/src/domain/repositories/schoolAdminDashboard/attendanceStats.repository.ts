// repositories/attendanceStats.repository.ts
import { Model, Types } from "mongoose";
import { IDetailsRecord } from "../../models";
import DateUtils from "../../../common/utils/DateUtils";
import { AttendanceStatusEnum } from "../../../common/enum/attendanceStatus.enum";
import { ClassAttendanceStats } from "../../../common/interfaces/classAttendanceStats.interface";

class AttendanceStatsRepository {
  private readonly detailsRecordModel: Model<IDetailsRecord>;

  constructor(detailsRecordModel: Model<IDetailsRecord>) {
    this.detailsRecordModel = detailsRecordModel;
  }

  /**
   * Lấy thống kê điểm danh chi tiết cho 1 trường trong ngày
   * @param schoolId id của trường
   * @param date ngày cần lấy thống kê
   */
  async getAttendanceStatsBySchool(
    schoolId: string,
    date?: Date
  ): Promise<ClassAttendanceStats[]> {
    const match: any = { "attendance.schoolId": new Types.ObjectId(schoolId) };

    // luôn mặc định là hôm nay (theo VN) nếu không truyền date
    const targetDate = date ?? new Date();

    // VN = UTC+7, cần convert sang UTC để query trên Mongo Atlas
    const { start, end } = DateUtils.getUtcDayRange(targetDate);

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
          present: {
            $sum: {
              $cond: [{ $eq: ["$status", AttendanceStatusEnum.Present] }, 1, 0],
            },
          },
          absentWithLeave: {
            $sum: {
              $cond: [
                { $eq: ["$status", AttendanceStatusEnum.AbsentWithLeave] },
                1,
                0,
              ],
            },
          },
          absent: {
            $sum: {
              $cond: [{ $eq: ["$status", AttendanceStatusEnum.Absent] }, 1, 0],
            },
          },
          late: {
            $sum: {
              $cond: [{ $eq: ["$status", AttendanceStatusEnum.Late] }, 1, 0],
            },
          },
          leftEarly: {
            $sum: {
              $cond: [
                { $eq: ["$status", AttendanceStatusEnum.LeftEarly] },
                1,
                0,
              ],
            },
          },
        },
      },
      {
        $project: {
          _id: 0,
          className: 1,
          total: 1,
          present: 1,
          absentWithLeave: 1,
          absent: 1,
          late: 1,
          leftEarly: 1,
        },
      },
      { $sort: { className: 1 } },
    ]);
  }
}

export default AttendanceStatsRepository;
