import { z } from "zod";
import { Types } from "mongoose";

// Định nghĩa enum cho type
const TypeEnum = ["system", "reminder", "warning"] as const;

export const NotificationSchema = z.object({
  _id: z
    .string()
    .refine((val) => Types.ObjectId.isValid(val), {
      message: "Invalid ObjectId format for _id",
    })
    .optional(), // MongoDB tự sinh
  userId: z
    .string()
    .min(1, { message: "userId is required" })
    .refine((val) => Types.ObjectId.isValid(val), {
      message: "Invalid ObjectId format for userId",
    }), // Bắt buộc, kiểm tra format ObjectId
  content: z
    .string()
    .max(1000, { message: "Content cannot exceed 1000 characters" })
    .optional(), // Không bắt buộc, validate độ dài
  type: z.enum(TypeEnum).optional(), // Không bắt buộc, giới hạn trong enum
  isRead: z.boolean().optional(), // Không bắt buộc, boolean
  createdAt: z
    .string()
    .datetime({ message: "Invalid date format for createdAt" })
    .optional(), // MongoDB tự set
});

export type Notification = z.infer<typeof NotificationSchema>;
export const CreateNotificationSchema = NotificationSchema.omit({ _id: true, createdAt: true });
export const UpdateNotificationSchema = NotificationSchema.partial({
  userId: true,
  content: true,
  type: true,
  isRead: true,
});