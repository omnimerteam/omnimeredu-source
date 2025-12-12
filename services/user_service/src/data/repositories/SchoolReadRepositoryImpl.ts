import { ISchoolReadRepository } from "../../domain/repositories/ISchoolReadRepository";
import { SchoolReadModel } from "../datasources/mongodb/schemas/SchoolReadSchema";

export class SchoolReadRepositoryImpl implements ISchoolReadRepository {
  async findById(id: string): Promise<any> {
    return await SchoolReadModel.findOne({ _id: id }).lean();
  }

  async findByCode(code: string): Promise<any> {
    return await SchoolReadModel.findOne({ code }).lean();
  }

  async findAll(limit: number = 50, offset: number = 0): Promise<any[]> {
    return await SchoolReadModel.find()
      .skip(offset)
      .limit(limit)
      .sort({ createdAt: -1 })
      .lean();
  }

  async findByLevel(level: string): Promise<any[]> {
    return await SchoolReadModel.find({ level }).sort({ createdAt: -1 }).lean();
  }
}
