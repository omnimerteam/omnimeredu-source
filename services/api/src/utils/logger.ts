import mongoose, { Types } from "mongoose";
import { ActivityLogRepository } from "../repositories/activityLog.repository";

const activityLogRepo = new ActivityLogRepository();

/**
 * Ghi log hoạt động của người dùng
 * @param options Các thông tin cần thiết để log
 */
export async function logActivity(options: {
  userId: string | Types.ObjectId;
  action: string;
  targetId?: string | Types.ObjectId;
  roleSnapshot?: string;
  metadata?: object;
}) {
  try {
    const { userId, action, targetId, roleSnapshot, metadata } = options;

    await activityLogRepo.createLog({
      userId:
        typeof userId === "string"
          ? new mongoose.Types.ObjectId(userId)
          : userId,
      action,
      targetId: targetId
        ? typeof targetId === "string"
          ? new mongoose.Types.ObjectId(targetId)
          : targetId
        : undefined,
      roleSnapshot,
      metadata,
    });
  } catch (error) {
    // Không throw tránh làm lỗi hệ thống
    console.error("[ActivityLogger] Failed to write log:", error);
  }
}
