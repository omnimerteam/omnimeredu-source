import { Tuition } from "../entities/Tuition";

export interface ITuitionRepository {
  create(tuition: Tuition): Promise<Tuition>;
  findById(id: string): Promise<Tuition | null>;
  findByStudentAndPeriod(
    studentId: string,
    periodStart: Date
  ): Promise<Tuition | null>;
  findBySchoolAndPeriod(
    schoolId: string,
    periodStart: Date,
    periodEnd: Date
  ): Promise<Tuition[]>;
  findByStatus(status: string): Promise<Tuition[]>;
  update(tuition: Tuition): Promise<Tuition>;
  delete(id: string): Promise<boolean>;
}
