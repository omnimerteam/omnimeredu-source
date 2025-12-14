import { IClassReadRepository } from "../../domain/repositories/IClassReadRepository";
import { ClassReadModel } from "../datasources/mongodb/schemas/ClassReadSchema";
import { UserFullReadModel } from "../datasources/mongodb/schemas/UserFullReadSchema";

export class ClassReadRepositoryImpl implements IClassReadRepository {
  async findById(id: string): Promise<any> {
    return await ClassReadModel.findOne({ _id: id }).lean();
  }

  async findBySchoolId(schoolId: string): Promise<any[]> {
    return await ClassReadModel.find({ schoolId }).sort({ name: 1 }).lean();
  }

  async findByGradeId(gradeId: string): Promise<any[]> {
    return await ClassReadModel.find({ gradeId }).sort({ name: 1 }).lean();
  }

  async findStudentsByClassId(classId: string): Promise<any[]> {
    // Query students from UserFullReadModel where student.classId matches
    return await UserFullReadModel.find({
      "student.classId": classId,
      role: "student",
    })
      .select("_id fullName email avatar student")
      .lean();
  }
}
