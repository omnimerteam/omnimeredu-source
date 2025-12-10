export interface IGradeReadRepository {
  findById(id: string): Promise<any>;
  findBySchoolId(schoolId: string): Promise<any[]>;
  findActiveBySchoolId(schoolId: string): Promise<any[]>;
}
