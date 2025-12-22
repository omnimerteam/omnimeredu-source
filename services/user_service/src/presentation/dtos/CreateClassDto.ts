export class CreateClassDto {
  name!: string;
  code?: string;
  schoolId!: string;
  gradeId!: string;
  maxStudents?: number;
  baseFee?: number;
}
