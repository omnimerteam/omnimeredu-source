import {
  IAttendanceReadRepository,
  ClassMonthlyReport,
  MonthlyAttendanceStats,
  StudentAttendanceDetail,
} from "../../domain/repositories/IAttendanceReadRepository";
import { AttendanceReadModel } from "../datasources/mongodb/schemas/AttendanceReadSchema";
import { AttendanceRecordReadModel } from "../datasources/mongodb/schemas/AttendanceRecordReadSchema";

interface AttendanceSession {
  _id: string;
  classId: string;
  schoolId: string;
  date: Date;
  sessionType: string;
}

interface AttendanceRecordDoc {
  _id: string;
  studentId: string;
  attendanceId: string;
  status: string;
  note?: string;
}

export class AttendanceReadRepositoryImpl implements IAttendanceReadRepository {
  /**
   * Get monthly attendance report for a class
   * Uses MongoDB aggregation for optimized performance
   */
  async getMonthlyReport(
    classId: string,
    month: number,
    year: number
  ): Promise<ClassMonthlyReport> {
    const startDate = new Date(year, month - 1, 1);
    const endDate = new Date(year, month, 0); // Last day of the month

    // Get all attendance sessions for the class in the month
    const attendanceSessions = (await AttendanceReadModel.find({
      classId,
      date: { $gte: startDate, $lte: endDate },
    }).lean()) as AttendanceSession[];

    const attendanceIds = attendanceSessions.map(
      (a: AttendanceSession) => a._id
    );
    const schoolId =
      attendanceSessions.length > 0 ? attendanceSessions[0].schoolId : "";

    // Get all attendance records for these sessions
    const records = (await AttendanceRecordReadModel.find({
      attendanceId: { $in: attendanceIds },
    }).lean()) as AttendanceRecordDoc[];

    // Group records by student
    const studentRecords = new Map<string, AttendanceRecordDoc[]>();
    records.forEach((record: AttendanceRecordDoc) => {
      const studentId = record.studentId;
      if (!studentRecords.has(studentId)) {
        studentRecords.set(studentId, []);
      }
      studentRecords.get(studentId)!.push(record);
    });

    // Calculate stats for each student
    const totalSchoolDays = attendanceSessions.length;
    const students: MonthlyAttendanceStats[] = [];

    studentRecords.forEach(
      (studentRecs: AttendanceRecordDoc[], studentId: string) => {
        const presentDays = studentRecs.filter(
          (r: AttendanceRecordDoc) => r.status === "Present"
        ).length;
        const absentDays = studentRecs.filter(
          (r: AttendanceRecordDoc) => r.status === "Absent"
        ).length;
        const absentWithLeaveDays = studentRecs.filter(
          (r: AttendanceRecordDoc) => r.status === "AbsentWithLeave"
        ).length;
        const lateDays = studentRecs.filter(
          (r: AttendanceRecordDoc) => r.status === "Late"
        ).length;
        const leftEarlyDays = studentRecs.filter(
          (r: AttendanceRecordDoc) => r.status === "LeftEarly"
        ).length;

        const attendanceRate =
          totalSchoolDays > 0
            ? Math.round(
                ((presentDays + lateDays + leftEarlyDays) / totalSchoolDays) *
                  100
              )
            : 0;

        students.push({
          studentId,
          totalDays: totalSchoolDays,
          presentDays,
          absentDays,
          absentWithLeaveDays,
          lateDays,
          leftEarlyDays,
          attendanceRate,
        });
      }
    );

    // Calculate average attendance rate
    const averageAttendanceRate =
      students.length > 0
        ? Math.round(
            students.reduce(
              (sum: number, s: MonthlyAttendanceStats) =>
                sum + s.attendanceRate,
              0
            ) / students.length
          )
        : 0;

    return {
      classId,
      schoolId,
      month,
      year,
      totalSchoolDays,
      students,
      averageAttendanceRate,
    };
  }

  /**
   * Get attendance records for a specific student in a date range
   */
  async getStudentAttendanceHistory(
    studentId: string,
    startDate: Date,
    endDate: Date
  ): Promise<StudentAttendanceDetail[]> {
    // Get student's attendance records in the date range
    const records = (await AttendanceRecordReadModel.find({
      studentId,
    }).lean()) as AttendanceRecordDoc[];

    // Get corresponding attendance sessions
    const attendanceIds = [
      ...new Set(records.map((r: AttendanceRecordDoc) => r.attendanceId)),
    ];
    const sessions = (await AttendanceReadModel.find({
      _id: { $in: attendanceIds },
      date: { $gte: startDate, $lte: endDate },
    }).lean()) as AttendanceSession[];

    // Create a map of session details
    const sessionMap = new Map<string, AttendanceSession>(
      sessions.map((s: AttendanceSession) => [s._id, s])
    );

    // Combine records with session details
    const result: StudentAttendanceDetail[] = [];
    records.forEach((record: AttendanceRecordDoc) => {
      const session = sessionMap.get(record.attendanceId);
      if (session) {
        result.push({
          date: session.date,
          sessionType: session.sessionType,
          status: record.status,
          note: record.note,
        });
      }
    });

    // Sort by date descending
    result.sort(
      (a, b) => new Date(b.date).getTime() - new Date(a.date).getTime()
    );

    return result;
  }

  /**
   * Get daily attendance summary for a school
   */
  async getDailySchoolSummary(
    schoolId: string,
    date: Date
  ): Promise<{
    totalStudents: number;
    presentCount: number;
    absentCount: number;
    lateCount: number;
  }> {
    // Normalize date to start of day
    const dayStart = new Date(date);
    dayStart.setHours(0, 0, 0, 0);
    const dayEnd = new Date(date);
    dayEnd.setHours(23, 59, 59, 999);

    // Get all attendance sessions for the school on this date
    const sessions = (await AttendanceReadModel.find({
      schoolId,
      date: { $gte: dayStart, $lte: dayEnd },
    }).lean()) as AttendanceSession[];

    const attendanceIds = sessions.map((s: AttendanceSession) => s._id);

    // Aggregate attendance records
    const aggregation = await AttendanceRecordReadModel.aggregate([
      { $match: { attendanceId: { $in: attendanceIds } } },
      {
        $group: {
          _id: null,
          totalStudents: { $sum: 1 },
          presentCount: {
            $sum: { $cond: [{ $eq: ["$status", "Present"] }, 1, 0] },
          },
          absentCount: {
            $sum: {
              $cond: [
                {
                  $in: ["$status", ["Absent", "AbsentWithLeave"]],
                },
                1,
                0,
              ],
            },
          },
          lateCount: {
            $sum: { $cond: [{ $eq: ["$status", "Late"] }, 1, 0] },
          },
        },
      },
    ]);

    if (aggregation.length === 0) {
      return {
        totalStudents: 0,
        presentCount: 0,
        absentCount: 0,
        lateCount: 0,
      };
    }

    return {
      totalStudents: aggregation[0].totalStudents,
      presentCount: aggregation[0].presentCount,
      absentCount: aggregation[0].absentCount,
      lateCount: aggregation[0].lateCount,
    };
  }
}
