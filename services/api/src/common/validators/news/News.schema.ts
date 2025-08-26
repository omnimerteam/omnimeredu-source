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

  quillDelta: z.any().optional(),

  imagePath: z.string().optional(), // đường dẫn trong Firebase Storage bucket
  imageUrl: z.string().url({ message: "Định dạng ảnh không đúng" }).optional(),

  schoolId: z
    .string()
    .refine((val) => !val || Types.ObjectId.isValid(val), {
      message: "Định dạng ObjectId không hợp lệ cho schoolId",
    })
    .optional(),

  publishedAt: z
    .string()
    .datetime({ message: "Định dạng ngày giờ đăng không hợp lệ" })
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
