import { ISchoolRepository } from "../../repositories/ISchoolRepository";
import { School } from "../../entities/School";

export class GetSchoolByIdUseCase {
  constructor(private schoolRepository: ISchoolRepository) {}

  async execute(id: string): Promise<School | null> {
    return await this.schoolRepository.findById(id);
  }
}
