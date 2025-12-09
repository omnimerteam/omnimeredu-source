export class Class {
  constructor(
    public id: string,
    public name: string,
    public code: string,
    public schoolId: string,
    public gradeId: string,
    public maxStudents: number,
    public baseFee: number,
    public students?: string[], // List of Student IDs
    public createdAt?: Date,
    public updatedAt?: Date
  ) {}
}
