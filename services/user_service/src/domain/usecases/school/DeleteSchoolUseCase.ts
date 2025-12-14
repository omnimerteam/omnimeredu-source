import { ISchoolRepository } from "../../repositories/ISchoolRepository";

export class DeleteSchoolUseCase {
  constructor(private schoolRepository: ISchoolRepository) {}

  async execute(id: string): Promise<boolean> {
    const school = await this.schoolRepository.findById(id);
    if (!school) {
      throw new Error("School not found");
    }

    return await this.schoolRepository.delete(id);
  }
}
