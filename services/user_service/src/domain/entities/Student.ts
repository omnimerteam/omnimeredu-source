import { EducationSystemLevelsEnum, EducationGradesEnum } from "shared-lib";

export class Student {
  constructor(
    public id: string,
    public userId: string,
    public educationLevel: EducationSystemLevelsEnum,
    public gradeGroup: EducationGradesEnum,
    public classId?: string | null,
    public guardianName?: string,
    public guardianPhone?: string,
    public meta?: Record<string, any>,
    public createdAt?: Date,
    public updatedAt?: Date
  ) {}
}
