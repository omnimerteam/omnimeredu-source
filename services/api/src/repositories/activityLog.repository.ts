import { Model, Types } from "mongoose";
import { IActivityLog } from "../models/ActivityLog"; // đường dẫn đúng tùy dự án
import ActivityLogModel from "../models/ActivityLog";

export class ActivityLogRepository {
  private readonly model: Model<IActivityLog>;

  constructor() {
    this.model = ActivityLogModel;
  }

  /**
   * Tạo log hoạt động
   * @param data Thông tin log
   */
  async createLog(data: {
    userId: Types.ObjectId;
    action: string;
    targetId?: Types.ObjectId;
    roleSnapshot?: string;
    metadata?: object;
  }): Promise<IActivityLog> {
    const log = new this.model({
      ...data,
      timestamp: new Date(),
    });
    return await log.save();
  }

  /**
   * Lấy danh sách log theo người dùng
   * @param userId ID của người dùng
   */
  async getLogsByUser(userId: Types.ObjectId): Promise<IActivityLog[]> {
    return await this.model.find({ userId }).sort({ timestamp: -1 }).exec();
  }

  /**
   * Tìm log theo hành động
   * @param action Tên hành động
   */
  async getLogsByAction(action: string): Promise<IActivityLog[]> {
    return await this.model.find({ action }).sort({ timestamp: -1 }).exec();
  }

  /**
   * Xóa tất cả log theo targetId (thận trọng)
   */
  async deleteLogsByTarget(targetId: Types.ObjectId): Promise<number> {
    const result = await this.model.deleteMany({ targetId });
    return result.deletedCount || 0;
  }

  /**
   * Lấy tất cả logs với tuỳ chọn phân trang
   */
  async getAllLogs(limit = 50, skip = 0): Promise<IActivityLog[]> {
    return await this.model
      .find()
      .sort({ timestamp: -1 })
      .skip(skip)
      .limit(limit)
      .exec();
  }
}
