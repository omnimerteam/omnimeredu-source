import { z } from "zod";
import { Types } from "mongoose";

// Định nghĩa enum cho loại thông báo
export const TypeEnum = ["system", "reminder", "warning"] as const;

export const NotificationSchema = z.object({
  _id: z
    .string()
    .refine((val) => Types.ObjectId.isValid(val), {
      message: "Định dạng ObjectId không hợp lệ cho _id",
    })
    .optional(), // MongoDB tự sinh

  userId: z
    .string()
    .min(1, { message: "userId là bắt buộc" })
    .refine((val) => Types.ObjectId.isValid(val), {
      message: "Định dạng ObjectId không hợp lệ cho userId",
    }),

  content: z
    .string()
    .min(1, { message: "Nội dung là bắt buộc" })
    .max(1000, { message: "Nội dung không được vượt quá 1000 ký tự" })
    .optional(),

  type: z
    .enum(TypeEnum, {
      message: `Loại thông báo phải là một trong: ${TypeEnum.join(", ")}`,
    })
    .optional(),

  isRead: z.boolean().optional(),

  createdAt: z
    .string()
    .datetime({ message: "Định dạng ngày giờ không hợp lệ cho createdAt" })
    .optional(),
});

export type Notification = z.infer<typeof NotificationSchema>;
