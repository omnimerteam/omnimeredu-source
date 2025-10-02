import { FilterQuery, Model } from "mongoose";
import { BaseRepository } from "../base.repository";
import { IStudent } from "../../models";
import { PaginationQueryOptions } from "../../../common/utils/buildQueryOptions";
import chalk from "chalk";

class StudentRepository extends BaseRepository<IStudent> {
  constructor(studentModel: Model<IStudent>) {
    super(studentModel);
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

    console.log(chalk.green("finalFilter: ", finalFilter));

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
