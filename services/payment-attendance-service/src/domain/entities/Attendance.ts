export class Attendance {
  constructor(
    public id: string,
    public classId: string,
    public schoolId: string,
    public date: Date,
    public sessionType: "regular" | "weekend" | "holiday" | "extra",
    public createdAt?: Date,
    public updatedAt?: Date
  ) {}
}
