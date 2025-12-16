import { SchoolRepositoryImpl } from "../../../data/repositories/SchoolRepositoryImpl";
import { School } from "../../entities/School";
import { EducationSystemLevelsEnum } from "shared-lib";

export interface SearchSchoolsOptions {
  educationLevel?: EducationSystemLevelsEnum;
  search?: string;
  limit?: number;
  offset?: number;
}

export class SearchSchoolsUseCase {
  constructor(private schoolRepository: SchoolRepositoryImpl) {}

  async execute(options: SearchSchoolsOptions): Promise<School[]> {
    const { educationLevel, search, limit = 20, offset = 0 } = options;

    return await this.schoolRepository.searchSchools({
      educationLevel,
      search,
      limit,
      offset,
    });
  }
}
