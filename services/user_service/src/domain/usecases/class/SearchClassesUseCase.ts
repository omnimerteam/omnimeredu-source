import { ClassRepositoryImpl } from "../../../data/repositories/ClassRepositoryImpl";
import { Class } from "../../entities/Class";

export interface SearchClassesOptions {
  query?: string;
  schoolId?: string;
  gradeId?: string;
  limit?: number;
  offset?: number;
}

export class SearchClassesUseCase {
  constructor(private classRepository: ClassRepositoryImpl) {}

  async execute(schoollId: string): Promise<Class[]> {
    return await this.classRepository.searchClasses(schoollId);
  }
}
