import { Grade } from "../entities/Grade";

export interface IGradeRepository {
  create(grade: Grade): Promise<Grade>;
  findById(id: string): Promise<Grade | null>;
  findBySchoolId(schoolId: string): Promise<Grade[]>;
  update(grade: Grade): Promise<Grade>;
  delete(id: string): Promise<boolean>;
}
