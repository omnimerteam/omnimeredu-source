import { EducationSystemLevelsEnum } from "shared-lib";

export class CreateSchoolDto {
  name!: string;
  code?: string;
  address!: string;
  level!: EducationSystemLevelsEnum;
  adminId?: string;
  phone?: string;
  description?: string;
  logoUrl?: string;
  customTheme?: object;
}
