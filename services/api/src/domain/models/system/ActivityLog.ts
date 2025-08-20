import mongoose, { Schema, Document, Types } from "mongoose";

export interface IActivityLog extends Document {
  _id: Types.ObjectId; // ID của log, được MongoDB tự sinh ra
  userId: Types.ObjectId; // ID của người dùng thực hiện hành động
  action: string; // Hành động cụ thể (vd: 'deleteUser', 'updateClass')
  targetId?: Types.ObjectId; // ID đối tượng bị tác động (vd: user bị xóa, class bị sửa)
  roleSnapshot?: string; // Ghi lại vai trò của người dùng tại thời điểm đó (vd: 'SchoolAdmin')
  timestamp: Date; // Thời điểm xảy ra hành động
  metadata?: object; // Dữ liệu bổ sung (vd: IP, lý do, dữ liệu cũ/mới...)
}

const ActivityLogSchema = new Schema<IActivityLog>({
  _id: { type: Schema.Types.ObjectId, auto: true },
  userId: { type: Schema.Types.ObjectId, ref: "User", required: true },
  action: { type: String, required: true },
  targetId: Schema.Types.ObjectId,
  roleSnapshot: String,
  timestamp: { type: Date, default: Date.now },
  metadata: Schema.Types.Mixed,
});

export default mongoose.model<IActivityLog>("ActivityLog", ActivityLogSchema);
