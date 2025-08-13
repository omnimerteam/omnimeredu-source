import { z } from "zod";
import { Types } from "mongoose";

export const NewsSchema = z.object({
  _id: z
    .string()
    .refine((val) => Types.ObjectId.isValid(val), {
      message: "Định dạng ObjectId không hợp lệ cho _id",
    })
    .optional(),

  title: z
    .string()
    .min(1, { message: "Tiêu đề là bắt buộc" })
    .max(200, { message: "Tiêu đề không được vượt quá 200 ký tự" }),

  content: z
    .string()
    .min(1, { message: "Nội dung là bắt buộc" })
    .max(10000, { message: "Nội dung không được vượt quá 10.000 ký tự" }),

  imageUrl: z
    .string()
    .url({ message: "Định dạng URL không hợp lệ cho imageUrl" })
    .optional(),

  schoolId: z
    .string()
    .refine((val) => !val || Types.ObjectId.isValid(val), {
      message: "Định dạng ObjectId không hợp lệ cho schoolId",
    })
    .optional(),

  publishedAt: z
    .string()
    .datetime({ message: "Định dạng ngày giờ không hợp lệ cho publishedAt" })
    .optional(),

  isPublic: z.boolean().optional(),

  tags: z
    .array(
      z
        .string()
        .max(50, { message: "Mỗi thẻ (tag) không được vượt quá 50 ký tự" })
    )
    .optional(),
});

export type News = z.infer<typeof NewsSchema>;
