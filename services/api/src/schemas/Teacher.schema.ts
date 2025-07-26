import { z } from "zod";
import { Types } from "mongoose";
import { BaseUserSchema } from "./BaseUser.schema";

// Định nghĩa schema cho Teacher, kế thừa từ BaseUserSchema
export const TeacherSchema = BaseUserSchema.extend({
  literacy: z
    .string()
    .max(200, { message: "Literacy cannot exceed 200 characters" })
    .optional(), // Không bắt buộc, validate độ dài
  subjects: z
    .array(z.string().max(100, { message: "Each subject cannot exceed 100 characters" }))
    .optional(), // Không bắt buộc, mảng chuỗi
  schoolId: z
    .string()
    .min(1, { message: "schoolId is required" })
    .refine((val) => Types.ObjectId.isValid(val), {
      message: "Invalid ObjectId format for schoolId",
    }), // Bắt buộc, kiểm tra format ObjectId
});

export type Teacher = z.infer<typeof TeacherSchema>;
export const CreateTeacherSchema = TeacherSchema.omit({ _id: true });
export const UpdateTeacherSchema = TeacherSchema.partial({
  fullName: true,
  roleId: true,
  gender: true,
  birthday: true,
  phone: true,
  address: true,
  isVerified: true,
  literacy: true,
  subjects: true,
  schoolId: true,
});