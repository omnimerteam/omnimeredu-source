import { GradeRepositoryImpl } from "../../../data/repositories/GradeRepositoryImpl";
import { EducationSystemLevelsEnum } from "shared-lib";

export interface GradeSelectOption {
  _id: string;
  name: string;
  level: EducationSystemLevelsEnum;
  schoolId: string;
}

export class GetGradesForSelectUseCase {
  constructor(private gradeRepository: GradeRepositoryImpl) {}

  async execute(schoolId?: string): Promise<GradeSelectOption[]> {
    const grades = await this.gradeRepository.findForSelect(schoolId);

    return grades.map((grade) => ({
      _id: grade._id,
      name: grade.name,
      level: grade.level,
      schoolId: grade.schoolId,
    }));
  }
}
