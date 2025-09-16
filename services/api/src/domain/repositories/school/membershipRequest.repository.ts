import { FilterQuery, Model } from "mongoose";
import { IMembershipRequest } from "../../models";
import { BaseRepository } from "../base.repository";
import { PaginationQueryOptions } from "../../../common/utils/buildQueryOptions";

class MembershipRequestRepository extends BaseRepository<IMembershipRequest> {
  constructor(membershipRequest: Model<IMembershipRequest>) {
    super(membershipRequest);
  }

  async findAllMembershipRequest(
    filter: FilterQuery<IMembershipRequest> = {},
    options?: PaginationQueryOptions
  ): Promise<IMembershipRequest[]> {
    const page = options?.page ?? 1;
    const limit = options?.limit ?? 20;
    const skip = (page - 1) * limit;
    const sort = options?.sort ?? { _id: -1 };

    const finalFilter = {
      ...filter,
      ...(options?.filter || {}),
    };

    return this.model
      .find(finalFilter)
      .skip(skip)
      .limit(limit)
      .sort(sort)
      .populate({
        path: "userId",
        select: "_id fullName",
      })
      .populate({
        path: "classId",
        select: "_id name code",
      })
      .populate({
        path: "schoolId",
        select: "_id name code",
      })
      .exec();
  }
}

export default MembershipRequestRepository;
