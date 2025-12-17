import { School } from "../entities/School";
import { EducationSystemLevelsEnum } from "shared-lib";

export interface SearchSchoolsOptions {
  educationLevel?: EducationSystemLevelsEnum;
  search?: string;
  limit?: number;
  offset?: number;
}

export interface ISchoolRepository {
  create(school: School): Promise<School>;
  findById(id: string): Promise<School | null>;
  findByCode(code: string): Promise<School | null>;
  update(school: School): Promise<School>;
  delete(id: string): Promise<boolean>;
  getSchoolsByLevel(params: {
    educationLevel: EducationSystemLevelsEnum;
    search?: string;
  }): Promise<School[]>;
  searchSchools(options: SearchSchoolsOptions): Promise<School[]>;
  findSchoolAdminByUserId(userId: string): Promise<{ schoolId: string } | null>;
}
