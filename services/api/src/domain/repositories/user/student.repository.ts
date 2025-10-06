import { FilterQuery, Model } from "mongoose";
import { BaseRepository } from "../base.repository";
import { IGrade, IStudent } from "../../models";
import { PaginationQueryOptions } from "../../../common/utils/buildQueryOptions";
import { HttpError } from "../../../common/utils/HttpError";

class StudentRepository extends BaseRepository<IStudent> {
  private readonly gradeModel: Model<IGrade>;
  constructor(studentModel: Model<IStudent>, gradeModel: Model<IGrade>) {
    super(studentModel);
    this.gradeModel = gradeModel;
  }

  async getStudentSelector(gradeId?: string, schoolId?: string) {
    let gradeGroup: string | undefined;

    if (gradeId) {
      const grade = await this.gradeModel.findById(gradeId, "gradeGroup");
      gradeGroup = grade?.gradeGroup;

      if (!gradeGroup) {
        throw new HttpError(404, "Lớp học không chính xác");
      }
    }

    // Xây query động
    const filter: any = {};
    if (schoolId) filter.schoolId = schoolId;
    if (gradeGroup) filter.gradeGroup = gradeGroup;

    return await this.model
      .find(filter, {
        _id: 1,
        fullName: 1,
        gender: 1,
        isVerified: 1,
        classId: 1,
        gradeGroup: 1,
      })
      .populate({
        path: "classId",
        select: "name",
      })
      .sort({ fullName: 1 })
      .exec();
  }

  async findAllStudent(
    filter: FilterQuery<IStudent> = {},
    options?: PaginationQueryOptions
  ): Promise<IStudent[]> {
    const page = options?.page ?? 1;
    const limit = options?.limit ?? 20;
    const skip = (page - 1) * limit;
    const sort = options?.sort ?? { _id: -1 };

    const finalFilter: FilterQuery<IStudent> = {
      ...filter,
      ...(options?.filter || {}),
    };

    // ✅ hỗ trợ search theo name (regex, không phân biệt hoa/thường)
    if (options?.search && options.search.trim() !== "") {
      finalFilter["fullName"] = {
        $regex: options.search.trim(),
        $options: "i",
      };
    }

    return this.model
      .find(finalFilter)
      .skip(skip)
      .limit(limit)
      .sort(sort)
      .exec();
  }

  async assignClassToStudents(
    studentIds: string[],
    classId: string
  ): Promise<any> {
    return this.model.updateMany(
      { _id: { $in: studentIds } },
      { $set: { classId } }
    );
  }

  async clearClassIdForStudents(studentIds: string[]): Promise<any> {
    return this.model.updateMany(
      { _id: { $in: studentIds } },
      { $unset: { classId: "" } }
    );
  }
}

export default StudentRepository;
