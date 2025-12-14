import { EducationSystemLevelsEnum, EducationGradesEnum } from "shared-lib";

export class CreateGradeDto {
  schoolId!: string;
  name!: string;
  level!: EducationSystemLevelsEnum;
  gradeGroup!: EducationGradesEnum;
  order!: number;
  active?: boolean;
  ageRange?: { min?: number; max?: number };
  description?: string;
  customFields?: object;
}
