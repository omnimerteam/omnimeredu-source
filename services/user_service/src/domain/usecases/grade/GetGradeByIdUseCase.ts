import { IGradeRepository } from "../../repositories/IGradeRepository";
import { Grade } from "../../entities/Grade";

export class GetGradeByIdUseCase {
  constructor(private gradeRepository: IGradeRepository) {}

  async execute(id: string): Promise<Grade | null> {
    return await this.gradeRepository.findById(id);
  }
}
