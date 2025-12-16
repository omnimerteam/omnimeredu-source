import { Student } from "../entities/Student";

export interface IStudentRepository {
  create(student: Student): Promise<Student>;
  findById(id: string): Promise<Student | null>;
  findByUserId(userId: string): Promise<Student | null>;
  findByClassId(classId: string): Promise<Student[]>;
  update(student: Student): Promise<Student>;
  delete(id: string): Promise<boolean>;
  updateClassForStudents(studentIds: string[], classId: string | null): Promise<void>;
  countStudentsInClass(classId: string): Promise<number>;
  findStudentsByParentId(parentId: string): Promise<Student[]>;
}