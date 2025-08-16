import { Model, Types } from "mongoose";
import News, { INews } from "../models/News";
import { BaseRepository } from "./base.repository";

class NewsRepository extends BaseRepository<INews> {
  constructor(newsModel: Model<INews>) {
    super(newsModel);
  }

  async getNewsBySchoolID(
    schoolId: string,
    options?: { page?: number; limit?: number; sort?: any }
  ): Promise<INews[]> {
    const page = options?.page || 1;
    const limit = options?.limit || 20;
    const skip = (page - 1) * limit;
    const sort = options?.sort || { publishedAt: -1 };

    return await News.find({ schoolId: new Types.ObjectId(schoolId) })
      .skip(skip)
      .sort(sort)
      .limit(limit)
      .exec();
  }
}

export default NewsRepository;
