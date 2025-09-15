export class AttendanceStatsEntity {
  attendanceRate: number; // tỷ lệ điểm danh toàn trường
  classAttendanceRates: Record<string, number>; // map { className: rate }
  date: Date;

  constructor(data: {
    attendanceRate: number;
    classAttendanceRates: Record<string, number>;
    date: Date;
  }) {
    this.attendanceRate = data.attendanceRate;
    this.classAttendanceRates = data.classAttendanceRates;
    this.date = data.date;
  }
}
