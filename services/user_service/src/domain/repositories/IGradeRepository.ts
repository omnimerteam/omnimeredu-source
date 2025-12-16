import { Grade } from "../entities/Grade";
import { EducationSystemLevelsEnum } from "shared-lib";

export interface PaginationOptions {
  page?: number;
  limit?: number;
  sortBy?: string;
  sortOrder?: "asc" | "desc";
}

export interface FilterOptions {
  schoolId?: string;
  level?: EducationSystemLevelsEnum;
  active?: boolean;
}

export interface GradeSelectOption {
  _id: string;
  name: string;
  level: EducationSystemLevelsEnum;
  schoolId: string;
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

export interface IGradeRepository {
  create(grade: Grade): Promise<Grade>;
  findById(id: string): Promise<Grade | null>;
  findBySchoolId(schoolId: string): Promise<Grade[]>;
  update(grade: Grade): Promise<Grade>;
  delete(id: string): Promise<boolean>;
  findAllWithPagination(
    skip: number,
    limit: number,
    sortBy: string,
    sortOrder: "asc" | "desc",
    filters: FilterOptions
  ): Promise<Grade[]>;
  count(filters: FilterOptions): Promise<number>;
  findForSelect(schoolId?: string): Promise<GradeSelectOption[]>;
}
