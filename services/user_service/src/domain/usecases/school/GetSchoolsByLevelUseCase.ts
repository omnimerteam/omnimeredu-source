import { ISchoolRepository } from "../../repositories/ISchoolRepository";

export class GetSchoolsByLevelUseCase {
  constructor(private schoolRepository: ISchoolRepository) {}

  async execute(params: {
    educationLevel: string;
    search?: string;
  }): Promise<any[]> {
    return await this.schoolRepository.getSchoolsByLevel(params);
  }
}
