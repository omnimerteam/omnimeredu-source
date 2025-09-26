import { PaginationQueryOptions } from "../../../common/utils/buildQueryOptions";
import { IBaseUser } from "../../models";
import { BaseRepository } from "../base.repository";

import { Model, FilterQuery } from "mongoose";
class PersonnelRepository extends BaseRepository<IBaseUser> {
  constructor(model: Model<IBaseUser>) {
    super(model);
  }

  async findAllPersonnel(
    filter: FilterQuery<IBaseUser> = {},
    options?: PaginationQueryOptions
  ): Promise<IBaseUser[]> {
    const page = options?.page ?? 1;
    const limit = options?.limit ?? 20;
    const skip = (page - 1) * limit;
    const sort = options?.sort ?? { _id: -1 };

    // ✅ Base filter: chỉ lấy Teacher và Staff
    const finalFilter: FilterQuery<IBaseUser> = {
      ...filter,
      ...(options?.filter || {}),
      roleKey: { $in: ["Teacher", "Staff", "SchoolAdmin"] },
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
      .populate({
        path: "roleId",
        select: "_id name",
      })
      .exec();
  }
}

export default PersonnelRepository;
