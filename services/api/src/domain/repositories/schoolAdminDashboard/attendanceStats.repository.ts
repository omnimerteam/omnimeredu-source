// repositories/attendanceStats.repository.ts
import { Model } from "mongoose";
import { IAttendance, IClass } from "../../models";
import { Mode } from "fs";

class AttendanceStatsRepository {
  private readonly attendanceModel: Model<IAttendance>;
  private readonly classModel: Model<IClass>;

  constructor(attendanceModel: Model<IAttendance>, classModel: Model<IClass>) {
    this.attendanceModel = attendanceModel;
    this.classModel = classModel;
  }

  /**
   * Lấy thống kê điểm danh cho 1 trường trong ngày
   * @param schoolId id của trường
   * @param date ngày cần lấy thống kê
   */
  async getStatsBySchool(schoolId: string, date: Date) {
    // Lấy danh sách lớp thuộc school
    const classes = await this.classModel.find({ schoolId });

    let totalStudents = 0;
    let totalPresent = 0;
    const classAttendanceRates: Record<string, number> = {};

    for (const cls of classes) {
      const studentsInClass = cls.students.length;

      if (studentsInClass === 0) {
        classAttendanceRates[cls.name] = 0;
        continue;
      }

      const presentCount = await this.attendanceModel.countDocuments({
        classId: cls._id,
        date,
        status: "Present",
      });

      const rate = presentCount / studentsInClass;
      classAttendanceRates[cls.name] = Number(rate.toFixed(2));

      totalStudents += studentsInClass;
      totalPresent += presentCount;
    }

    const attendanceRate =
      totalStudents > 0 ? Number((totalPresent / totalStudents).toFixed(2)) : 0;

    return {
      attendanceRate,
      classAttendanceRates,
      date,
    };
  }
}

export default AttendanceStatsRepository;
