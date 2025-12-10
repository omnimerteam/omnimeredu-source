import { ISchoolReadRepository } from "../../repositories/ISchoolReadRepository";

export class GetSchoolsUseCase {
  constructor(private schoolReadRepository: ISchoolReadRepository) {}

  async execute(limit?: number, offset?: number): Promise<any[]> {
    return await this.schoolReadRepository.findAll(limit, offset);
  }
}
