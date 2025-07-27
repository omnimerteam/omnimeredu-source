import { z } from "zod";
import { Types } from "mongoose";

// Định nghĩa schema cho TeachingAssignment
export const TeachingAssignmentSchema = z.object({
  _id: z
    .string()
    .refine((val) => Types.ObjectId.isValid(val), {
      message: "Invalid ObjectId format for _id",
    })
    .optional(), // MongoDB tự sinh
  teacherId: z
    .string()
    .min(1, { message: "teacherId is required" })
    .refine((val) => Types.ObjectId.isValid(val), {
      message: "Invalid ObjectId format for teacherId",
    }), // Bắt buộc, kiểm tra format ObjectId
  classId: z
    .string()
    .min(1, { message: "classId is required" })
    .refine((val) => Types.ObjectId.isValid(val), {
      message: "Invalid ObjectId format for classId",
    }), // Bắt buộc, kiểm tra format ObjectId
  subject: z
    .string()
    .max(100, { message: "Subject cannot exceed 100 characters" })
    .optional(), // Không bắt buộc, validate độ dài
  isMain: z.boolean().optional(), // Không bắt buộc, boolean
});

export type TeachingAssignment = z.infer<typeof TeachingAssignmentSchema>;
export const CreateTeachingAssignmentSchema = TeachingAssignmentSchema.omit({ _id: true });
export const UpdateTeachingAssignmentSchema = TeachingAssignmentSchema.partial({
  teacherId: true,
  classId: true,
  subject: true,
  isMain: true,
});