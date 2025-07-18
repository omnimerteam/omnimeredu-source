import { Model, Types } from "mongoose";
import { IActivityLog } from "../models/ActivityLog";
import ActivityLogModel from "../models/ActivityLog";

export class ActivityLogRepository {
  private readonly model: Model<IActivityLog>;

  constructor(model: Model<IActivityLog> = ActivityLogModel) {
    this.model = model;
  }

  async createLog(data: {
    userId: Types.ObjectId;
    action: string;
    targetId?: Types.ObjectId;
    roleSnapshot?: string;
    metadata?: object;
  }): Promise<IActivityLog> {
    return await this.model.create({
      ...data,
      timestamp: new Date(),
    });
  }

  async getLogsByUser(userId: Types.ObjectId): Promise<IActivityLog[]> {
    return await this.model.find({ userId }).sort({ timestamp: -1 }).exec();
  }

  async getLogsByAction(action: string): Promise<IActivityLog[]> {
    return await this.model.find({ action }).sort({ timestamp: -1 }).exec();
  }

  async deleteLogsByTarget(targetId: Types.ObjectId): Promise<number> {
    const result = await this.model.deleteMany({ targetId });
    return result.deletedCount || 0;
  }

  async getAllLogs(limit = 50, skip = 0): Promise<IActivityLog[]> {
    return await this.model
      .find()
      .sort({ timestamp: -1 })
      .skip(skip)
      .limit(limit)
      .exec();
  }

  // Optional: count
  async countLogs(): Promise<number> {
    return await this.model.countDocuments();
  }
}
