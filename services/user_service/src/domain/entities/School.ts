import { EducationSystemLevelsEnum } from "shared-lib";

export class School {
  constructor(
    public id: string,
    public name: string,
    public code: string,
    public address: string,
    public level: EducationSystemLevelsEnum,
    public adminId?: string,
    public phone?: string,
    public description?: string,
    public logoUrl?: string,
    public studentCount: number = 0,
    public customTheme?: object,
    public createdAt?: Date,
    public updatedAt?: Date
  ) {}
}
