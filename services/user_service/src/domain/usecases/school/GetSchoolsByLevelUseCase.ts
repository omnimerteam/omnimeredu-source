import { EducationSystemLevelsEnum } from "shared-lib";
import { ISchoolRepository } from "../../repositories/ISchoolRepository";
import { School } from "../../entities/School";

export class GetSchoolsByLevelUseCase {
  constructor(private schoolRepository: ISchoolRepository) {}

  async execute(params: {
    educationLevel: EducationSystemLevelsEnum;
    search?: string;
  }): Promise<School[]> {
    return await this.schoolRepository.getSchoolsByLevel(params);
  }
}
