import { FilterQuery, Model, Types } from "mongoose";
import { IClass } from "../../../models";
import { BaseRepository } from "../../base.repository";

class ClassRepository extends BaseRepository<IClass> {
  constructor(ClassModel: Model<IClass>) {
    super(ClassModel);
  }

  /**
   * Hàm mở rộng riêng của ClassRepository
   */
  async findByCode(code: string): Promise<IClass | null> {
    return this.model.findOne({ code }).exec();
  }

  async addStudentsToClass(
    classId: string,
    studentIds: string[]
  ): Promise<IClass | null> {
    return this.model.findByIdAndUpdate(
      classId,
      { $addToSet: { students: { $each: studentIds } } },
      { new: true }
    );
  }

  async removeStudentsFromClass(
    classId: string,
    studentIds: string[]
  ): Promise<IClass | null> {
    return this.model.findByIdAndUpdate(
      classId,
      { $pull: { students: { $in: studentIds } } },
      { new: true }
    );
  }

  /**
   * Tìm lớp học theo schoolId + query (code hoặc name)
   * @param {String} schoolId
   * @param {String} query
   */
  async searchClassesInSchool(
    schoolId: string,
    query?: string
  ): Promise<IClass[]> {
    const filter: any = { schoolId: new Types.ObjectId(schoolId) };

    if (query?.trim()) {
      filter.$or = [
        { name: { $regex: query, $options: "i" } },
        { code: { $regex: query, $options: "i" } },
      ];
    }

    return this.model.find(filter).select("_id name code schoolId");
  }
}

export default ClassRepository;
