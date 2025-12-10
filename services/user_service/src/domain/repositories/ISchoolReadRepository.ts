export interface ISchoolReadRepository {
  findById(id: string): Promise<any>;
  findByCode(code: string): Promise<any>;
  findAll(limit?: number, offset?: number): Promise<any[]>;
  findByLevel(level: string): Promise<any[]>;
}
