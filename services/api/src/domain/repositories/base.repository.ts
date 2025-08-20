import { Model, Types, FilterQuery, UpdateQuery } from "mongoose";

/**
 * BaseRepository là class cơ sở để thao tác CRUD với Mongoose.
 * T có thể là bất kỳ interface nào đại diện cho dữ liệu (IClass, ISchool, IStudent, ...)
 */
export class BaseRepository<T> {
  protected readonly model: Model<T>;

  constructor(model: Model<T>) {
    this.model = model;
  }

  /**
   * Tìm tất cả bản ghi, có thể truyền query filter, phân trang, sort.
   * @param filter - điều kiện tìm kiếm (optional)
   * @param options - optional: limit, page, sort
   */
  async findAll(
    filter: FilterQuery<T> = {},
    options?: { page?: number; limit?: number; sort?: any }
  ): Promise<T[]> {
    const page = options?.page || 1;
    const limit = options?.limit || 20;
    const skip = (page - 1) * limit;
    const sort = options?.sort || { _id: -1 };

    return this.model.find(filter).skip(skip).limit(limit).sort(sort).exec();
  }

  /**
   * Tìm một bản ghi theo ID
   */
  async findById(id: string): Promise<T | null> {
    if (!Types.ObjectId.isValid(id)) return null;
    return this.model.findById(id).exec();
  }

  /**
   * Tìm một bản ghi duy nhất theo điều kiện
   */
  async findOne(filter: FilterQuery<T>): Promise<T | null> {
    return this.model.findOne(filter).exec();
  }

  /**
   * Tạo bản ghi mới
   */
  async create(data: Partial<T>): Promise<T> {
    return this.model.create(data);
  }

  /**
   * Cập nhật một bản ghi theo ID
   */
  async update(id: string, data: UpdateQuery<T>): Promise<T | null> {
    if (!Types.ObjectId.isValid(id)) return null;
    return this.model.findByIdAndUpdate(id, data, { new: true }).exec();
  }

  /**
   * Xoá một bản ghi theo ID
   */
  async delete(id: string): Promise<boolean> {
    if (!Types.ObjectId.isValid(id)) return false;
    const result = await this.model.findByIdAndDelete(id).exec();
    return result !== null;
  }
}
