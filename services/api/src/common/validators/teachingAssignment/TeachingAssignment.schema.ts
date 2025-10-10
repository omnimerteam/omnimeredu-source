import { z } from "zod";
import { Types } from "mongoose";

// Định nghĩa schema cho TeachingAssignment
export const TeachingAssignmentSchema = z.object({
  _id: z
    .string()
    .refine((val) => Types.ObjectId.isValid(val), {
      message: "Định dạng ObjectId không hợp lệ cho _id",
    })
    .optional(),
  teacherId: z
    .string()
    .min(1, { message: "teacherId là bắt buộc" })
    .refine((val) => Types.ObjectId.isValid(val), {
      message: "Định dạng ObjectId không hợp lệ cho teacherId",
    }),
  classId: z
    .string()
    .min(1, { message: "classId là bắt buộc" })
    .refine((val) => Types.ObjectId.isValid(val), {
      message: "Định dạng ObjectId không hợp lệ cho classId",
    }),
  subject: z
    .string()
    .max(100, { message: "Môn học không được vượt quá 100 ký tự" })
    .optional(),
  isMain: z.boolean().optional(),
});

export type TeachingAssignment = z.infer<typeof TeachingAssignmentSchema>;
