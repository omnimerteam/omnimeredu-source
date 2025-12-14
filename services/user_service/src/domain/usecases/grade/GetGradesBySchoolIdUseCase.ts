import { IGradeRepository } from "../../repositories/IGradeRepository";
import { Grade } from "../../entities/Grade";

export class GetGradesBySchoolIdUseCase {
  constructor(private gradeRepository: IGradeRepository) {}

  async execute(schoolId: string): Promise<Grade[]> {
    return await this.gradeRepository.findBySchoolId(schoolId);
  }
}
