import { IClassRepository } from "../../repositories/IClassRepository";

export class GetClassesBySchoolUseCase {
  constructor(private classRepository: IClassRepository) {}

  async execute(params: { schoolId: string; grade?: string }): Promise<any[]> {
    return await this.classRepository.getClassesBySchool(params);
  }
}
