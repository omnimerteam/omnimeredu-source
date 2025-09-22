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
   * Tìm lớp học theo schoolId
   * @param {String} schoolId
   */
  async searchClassesInSchool(schoolId: string): Promise<IClass[]> {
    try {
      if (!schoolId?.trim()) {
        throw new Error("schoolId là bắt buộc");
      }

      const classes = await this.model
        .aggregate([
          {
            $match: { schoolId: new Types.ObjectId(schoolId) },
          },
          {
            $lookup: {
              from: "grades",
              localField: "gradeId",
              foreignField: "_id",
              as: "grade",
            },
          },
          { $unwind: "$grade" },
          {
            $project: {
              _id: 1,
              name: 1,
              code: 1,
              schoolId: 1,
              gradeId: 1,
              gradeGroup: "$grade.gradeGroup", // lấy trực tiếp từ grade
            },
          },
        ])
        .exec();

      return classes;
    } catch (err) {
      console.error("Error searching classes in school:", err);
      throw err;
    }
  }
}

export default ClassRepository;
