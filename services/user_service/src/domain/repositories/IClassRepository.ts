import { Class } from "../entities/Class";

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

export interface SearchClassesOptions {
  query?: string;
  schoolId?: string;
  gradeId?: string;
  limit?: number;
  offset?: number;
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

export interface IClassRepository {
  create(classEntity: Class): Promise<Class>;
  findById(id: string): Promise<Class | null>;
  findByCode(code: string): Promise<Class | null>;
  findBySchoolId(schoolId: string): Promise<Class[]>;
  update(classEntity: Class): Promise<Class>;
  delete(id: string): Promise<boolean>;
  getClassesBySchool(params: {
    schoolId: string;
    grade?: string;
  }): Promise<any[]>;
  findAllWithPagination(
    skip: number,
    limit: number,
    sortBy: string,
    sortOrder: 'asc' | 'desc',
    filters: ClassFilterOptions
  ): Promise<Class[]>;
  count(filters: ClassFilterOptions): Promise<number>;
  searchClasses(options: SearchClassesOptions): Promise<Class[]>;
}
