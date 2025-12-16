import { ClassRepositoryImpl } from "../../../data/repositories/ClassRepositoryImpl";
import { Class } from "../../entities/Class";

export interface PaginationOptions {
  page?: number;
  limit?: number;
  sortBy?: string;
  sortOrder?: 'asc' | 'desc';
}

export interface ClassFilterOptions {
  gradeId?: string;
  maxStudents?: number;
  active?: boolean;
  schoolId?: string;
}

export interface PaginatedResult<T> {
  data: T[];
  pagination: {
    page: number;
    limit: number;
    total: number;
    totalPages: number;
    hasNext: boolean;
    hasPrev: boolean;
  };
}

export class GetAllClassesUseCase {
  constructor(private classRepository: ClassRepositoryImpl) {}

  async execute(
    pagination: PaginationOptions = {},
    filters: ClassFilterOptions = {}
  ): Promise<PaginatedResult<Class>> {
    const page = pagination.page || 1;
    const limit = Math.min(pagination.limit || 20, 100); // Max 100 items per page
    const skip = (page - 1) * limit;
    const sortBy = pagination.sortBy || 'name';
    const sortOrder = pagination.sortOrder || 'asc';

    const classes = await this.classRepository.findAllWithPagination(
      skip,
      limit,
      sortBy,
      sortOrder,
      filters
    );

    const total = await this.classRepository.count(filters);
    const totalPages = Math.ceil(total / limit);

    return {
      data: classes,
      pagination: {
        page,
        limit,
        total,
        totalPages,
        hasNext: page < totalPages,
        hasPrev: page > 1
      }
    };
  }
}