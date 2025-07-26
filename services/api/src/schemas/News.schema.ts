import { z } from "zod";
import { Types } from "mongoose";

export const NewsSchema = z.object({
  _id: z
    .string()
    .refine((val) => Types.ObjectId.isValid(val), {
      message: "Invalid ObjectId format for _id",
    })
    .optional(), // MongoDB tự sinh
  title: z
    .string()
    .min(1, { message: "Title is required" })
    .max(200, { message: "Title cannot exceed 200 characters" }), // Bắt buộc, validate độ dài
  content: z
    .string()
    .min(1, { message: "Content is required" })
    .max(10000, { message: "Content cannot exceed 10,000 characters" }), // Bắt buộc, validate độ dài
  imageUrl: z
    .string()
    .url({ message: "Invalid URL format for imageUrl" })
    .optional(), // Không bắt buộc, validate URL
  schoolId: z
    .string()
    .refine((val) => !val || Types.ObjectId.isValid(val), {
      message: "Invalid ObjectId format for schoolId",
    })
    .optional(), // Không bắt buộc, kiểm tra format nếu có
  publishedAt: z
    .string()
    .datetime({ message: "Invalid date format for publishedAt" })
    .optional(), // MongoDB tự set
  isPublic: z.boolean().optional(), // Không bắt buộc, boolean
  tags: z
    .array(z.string().max(50, { message: "Each tag cannot exceed 50 characters" }))
    .optional(), // Không bắt buộc, mảng chuỗi
});

export type News = z.infer<typeof NewsSchema>;
export const CreateNewsSchema = NewsSchema.omit({ _id: true, publishedAt: true });
export const UpdateNewsSchema = NewsSchema.partial({
  title: true,
  content: true,
  imageUrl: true,
  schoolId: true,
  isPublic: true,
  tags: true,
});