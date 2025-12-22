export interface IClassReadRepository {
  findById(id: string): Promise<any>;
  findBySchoolId(schoolId: string): Promise<any[]>;
  findByGradeId(gradeId: string): Promise<any[]>;
  findStudentsByClassId(classId: string): Promise<any[]>;
}
