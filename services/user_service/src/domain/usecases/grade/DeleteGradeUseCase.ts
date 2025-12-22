import { IGradeRepository } from "../../repositories/IGradeRepository";

export class DeleteGradeUseCase {
  constructor(private gradeRepository: IGradeRepository) {}

  async execute(id: string): Promise<boolean> {
    const grade = await this.gradeRepository.findById(id);
    if (!grade) {
      throw new Error("Grade not found");
    }

    return await this.gradeRepository.delete(id);
  }
}
