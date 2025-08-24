import mongoose, { Schema, Document, Types } from "mongoose";

export interface INotification extends Document {
  _id: Types.ObjectId;
  userId: Types.ObjectId;
  content: string;
  type: "system" | "reminder" | "warning";
  isRead: boolean;
  createdAt: Date;
}

const NotificationSchema = new Schema<INotification>({
  _id: { type: Schema.Types.ObjectId, auto: true },
  userId: { type: Schema.Types.ObjectId, ref: "BaseUser", required: true },
  content: String,
  type: {
    type: String,
    enum: ["system", "reminder", "warning"],
    default: "system",
  },
  isRead: { type: Boolean, default: false },
  createdAt: { type: Date, default: Date.now },
});

export default mongoose.model<INotification>(
  "Notification",
  NotificationSchema
);
