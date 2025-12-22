import { IGradeReadRepository } from "../../domain/repositories/IGradeReadRepository";
import { GradeReadModel } from "../datasources/mongodb/schemas/GradeReadSchema";

export class GradeReadRepositoryImpl implements IGradeReadRepository {
  async findById(id: string): Promise<any> {
    return await GradeReadModel.findOne({ _id: id }).lean();
  }

  async findBySchoolId(schoolId: string): Promise<any[]> {
    return await GradeReadModel.find({ schoolId }).sort({ order: 1 }).lean();
  }

  async findActiveBySchoolId(schoolId: string): Promise<any[]> {
    return await GradeReadModel.find({ schoolId, active: true })
      .sort({ order: 1 })
      .lean();
  }
}
