/**
 * Read-side Repository Interface for Attendance (MongoDB)
 * Used for optimized queries and aggregations
 */

export interface MonthlyAttendanceStats {
  studentId: string;
  totalDays: number;
  presentDays: number;
  absentDays: number;
  absentWithLeaveDays: number;
  lateDays: number;
  leftEarlyDays: number;
  attendanceRate: number; // Percentage
}

export interface ClassMonthlyReport {
  classId: string;
  schoolId: string;
  month: number;
  year: number;
  totalSchoolDays: number;
  students: MonthlyAttendanceStats[];
  averageAttendanceRate: number;
}

export interface StudentAttendanceDetail {
  date: Date;
  sessionType: string;
  status: string;
  note?: string;
}

export interface IAttendanceReadRepository {
  /**
   * Get monthly attendance report for a class
   * Aggregates data from MongoDB for optimized read performance
   */
  getMonthlyReport(
    classId: string,
    month: number,
    year: number
  ): Promise<ClassMonthlyReport>;

  /**
   * Get attendance records for a specific student in a date range
   */
  getStudentAttendanceHistory(
    studentId: string,
    startDate: Date,
    endDate: Date
  ): Promise<StudentAttendanceDetail[]>;

  /**
   * Get daily attendance summary for a school
   */
  getDailySchoolSummary(
    schoolId: string,
    date: Date
  ): Promise<{
    totalStudents: number;
    presentCount: number;
    absentCount: number;
    lateCount: number;
  }>;
}
