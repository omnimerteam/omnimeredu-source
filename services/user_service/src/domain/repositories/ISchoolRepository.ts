import { School } from "../entities/School";

export interface ISchoolRepository {
  create(school: School): Promise<School>;
  findById(id: string): Promise<School | null>;
  findByCode(code: string): Promise<School | null>;
  update(school: School): Promise<School>;
  delete(id: string): Promise<boolean>;
}
