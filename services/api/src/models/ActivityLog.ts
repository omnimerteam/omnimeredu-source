import mongoose, { Schema, Document, Types } from 'mongoose';

export interface IActivityLog extends Document {
  _id: Types.ObjectId;
  userId: Types.ObjectId;
  action: string;
  targetId?: Types.ObjectId;
  roleSnapshot?: string;
  timestamp: Date;
  metadata?: object;
}

const ActivityLogSchema = new Schema<IActivityLog>({
  _id: { type: Schema.Types.ObjectId, auto: true },
  userId: { type: Schema.Types.ObjectId, ref: 'User', required: true },
  action: { type: String, required: true },
  targetId: Schema.Types.ObjectId,
  roleSnapshot: String,
  timestamp: { type: Date, default: Date.now },
  metadata: Schema.Types.Mixed
});

export default mongoose.model<IActivityLog>('ActivityLog', ActivityLogSchema);