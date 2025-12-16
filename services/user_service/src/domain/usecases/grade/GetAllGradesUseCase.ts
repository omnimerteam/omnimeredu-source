import { GradeRepositoryImpl } from "../../../data/repositories/GradeRepositoryImpl";
import { Grade } from "../../entities/Grade";
import {
  PaginationUtil,
  PaginatedResponse,
} from "../../../infrastructure/utils/PaginationUtil";
import { EducationSystemLevelsEnum } from "shared-lib";

export interface PaginationOptions {
  page?: number;
  limit?: number;
  sortBy?: string;
  sortOrder?: "asc" | "desc";
  fields?: string[]; // Field selection
}

export interface FilterOptions {
  schoolId?: string;
  level?: EducationSystemLevelsEnum;
  active?: boolean;
  name?: string; // Add name filter for search
  search?: string; // Global search term
}

export interface GradeListOptions extends PaginationOptions {
  filters?: FilterOptions;
}

export class GetAllGradesUseCase {
  constructor(private gradeRepository: GradeRepositoryImpl) {}

  async execute(
    options: GradeListOptions = {}
  ): Promise<PaginatedResponse<Grade>> {
    const { filters = {}, ...paginationOptions } = options;

    // Parse pagination options
    const { page, limit, sortBy, sortOrder, offset } =
      PaginationUtil.parseOptions(paginationOptions);

    // Build order clause
    const orderClause = PaginationUtil.buildOrderClause(sortBy, sortOrder);

    // Get grades with enhanced filtering
    const grades = await this.gradeRepository.findAllWithPagination(
      offset,
      limit,
      sortBy,
      sortOrder,
      filters,
      paginationOptions.fields
    );

    // Get total count
    const total = await this.gradeRepository.count(filters);

    // Create paginated response
    return PaginationUtil.createResponse(
      grades,
      total,
      paginationOptions,
      filters
    );
  }
}
