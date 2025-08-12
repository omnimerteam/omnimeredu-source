import { Types } from "mongoose";
import { NotificationSchema, TypeEnum } from "../schemas/Notification.schema";
import z from "zod";

// Schema cho tạo mới thông báo
export const createNotificationBodySchema = NotificationSchema.omit({
  _id: true,
  createdAt: true,
}).extend({
  userId: z
    .string()
    .min(1, { message: "userId là bắt buộc" })
    .refine((val) => Types.ObjectId.isValid(val), {
      message: "Định dạng ObjectId không hợp lệ cho userId",
    }),

  content: z
    .string()
    .min(1, { message: "Nội dung là bắt buộc" })
    .max(1000, { message: "Nội dung không được vượt quá 1000 ký tự" }),

  type: z
    .enum(TypeEnum, {
      message: `Loại thông báo phải là một trong: ${TypeEnum.join(", ")}`,
    })
    .optional(),
});

// Schema cho cập nhật thông báo
export const updateNotificationBodySchema = NotificationSchema.partial({
  userId: true,
  content: true,
  type: true,
  isRead: true,
}).extend({
  userId: z
    .string()
    .refine((val) => Types.ObjectId.isValid(val), {
      message: "Định dạng ObjectId không hợp lệ cho userId",
    })
    .optional(),

  content: z
    .string()
    .max(1000, { message: "Nội dung không được vượt quá 1000 ký tự" })
    .optional(),

  type: z
    .enum(TypeEnum, {
      message: `Loại thông báo phải là một trong: ${TypeEnum.join(", ")}`,
    })
    .optional(),
});
