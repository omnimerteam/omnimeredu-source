export class AttendanceRecord {
  constructor(
    public id: string,
    public studentId: string,
    public attendanceId: string,
    public status:
      | "Present"
      | "AbsentWithLeave"
      | "Absent"
      | "Late"
      | "LeftEarly",
    public note?: string,
    public createdAt?: Date,
    public updatedAt?: Date
  ) {}
}
