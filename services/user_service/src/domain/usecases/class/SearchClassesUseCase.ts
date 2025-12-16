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

  async execute(options: SearchClassesOptions): Promise<Class[]> {
    const { query, schoolId, gradeId, limit = 20, offset = 0 } = options;

    return await this.classRepository.searchClasses({
      query,
      schoolId,
      gradeId,
      limit,
      offset
    });
  }
}