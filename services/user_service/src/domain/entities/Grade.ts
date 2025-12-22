import { EducationSystemLevelsEnum, EducationGradesEnum } from "shared-lib";

export class Grade {
  constructor(
    public id: string,
    public schoolId: string,
    public name: string,
    public level: EducationSystemLevelsEnum,
    public gradeGroup: EducationGradesEnum,
    public order: number,
    public active: boolean = true,
    public ageRange?: { min?: number; max?: number },
    public description?: string,
    public customFields?: Record<string, any>,
    public createdAt?: Date,
    public updatedAt?: Date
  ) {}
}
