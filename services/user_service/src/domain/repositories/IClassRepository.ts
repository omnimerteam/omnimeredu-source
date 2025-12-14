import { Class } from "../entities/Class";

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
}
