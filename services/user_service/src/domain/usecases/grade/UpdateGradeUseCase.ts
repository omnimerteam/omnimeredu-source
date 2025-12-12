import { IGradeRepository } from "../../repositories/IGradeRepository";
import { Grade } from "../../entities/Grade";
import { UpdateGradeDto } from "../../../presentation/dtos/UpdateGradeDto";

export class UpdateGradeUseCase {
  constructor(private gradeRepository: IGradeRepository) {}

  async execute(id: string, dto: UpdateGradeDto): Promise<Grade> {
    const existingGrade = await this.gradeRepository.findById(id);
    if (!existingGrade) {
      throw new Error("Grade not found");
    }

    // Update only provided fields
    const updatedGrade = new Grade(
      existingGrade.id,
      existingGrade.schoolId,
      dto.name ?? existingGrade.name,
      existingGrade.level,
      existingGrade.gradeGroup,
      dto.order ?? existingGrade.order,
      dto.active ?? existingGrade.active,
      dto.ageRange ?? existingGrade.ageRange,
      dto.description ?? existingGrade.description,
      dto.customFields ?? existingGrade.customFields
    );

    return await this.gradeRepository.update(updatedGrade);
  }
}
