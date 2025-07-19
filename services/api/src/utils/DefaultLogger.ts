import mongoose from "mongoose";
import { ILogger } from "../interfaces/logger.interface";
import { ActivityLogRepository } from "../repositories/activityLog.repository";

export class DefaultLogger implements ILogger {
  private readonly activityLogRepo: ActivityLogRepository;

  constructor(activityLogRepo?: ActivityLogRepository) {
    this.activityLogRepo = activityLogRepo ?? new ActivityLogRepository();
  }

  async log(options: {
    userId: string;
    action: string;
    targetId?: string;
    roleSnapshot?: string;
    metadata?: object;
  }): Promise<void> {
    try {
      const { userId, action, targetId, roleSnapshot, metadata } = options;

      await this.activityLogRepo.createLog({
        userId: new mongoose.Types.ObjectId(userId),
        action,
        targetId: targetId ? new mongoose.Types.ObjectId(targetId) : undefined,
        roleSnapshot,
        metadata,
      });
    } catch (error) {
      console.error("[DefaultLogger] ❌ Failed to write log:", error);
    }
  }
}
