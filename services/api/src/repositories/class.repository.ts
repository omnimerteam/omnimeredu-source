import { FilterQuery, Model } from "mongoose";
import { IClass } from "../models/school/class/Class";
import { BaseRepository } from "./base.repository";

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
}

export default ClassRepository;
