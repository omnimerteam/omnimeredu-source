import { IClassRepository } from "../../repositories/IClassRepository";
import { Class } from "../../entities/Class";

export class GetClassesBySchoolIdUseCase {
  constructor(private classRepository: IClassRepository) {}

  async execute(schoolId: string): Promise<Class[]> {
    return await this.classRepository.findBySchoolId(schoolId);
  }
}
