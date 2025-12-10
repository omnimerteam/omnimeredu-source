export class CreateAttendanceDto {
  classId!: string;
  schoolId!: string;
  date!: Date;
  sessionType?: "regular" | "weekend" | "holiday" | "extra";
}
