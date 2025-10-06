export interface ClassAttendanceStats {
  className: string;
  total: number;
  present: number;
  absentWithLeave: number;
  absent: number;
  late: number;
  leftEarly: number;
}
