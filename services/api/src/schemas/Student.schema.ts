import { z } from "zod";
import { Types } from "mongoose";
import { BaseUserSchema } from "./BaseUser.schema";

// Định nghĩa schema cho Student, kế thừa từ BaseUserSchema
export const StudentSchema = BaseUserSchema.extend({
  schoolId: z
    .string()
    .min(1, { message: "schoolId is required" })
    .refine((val) => Types.ObjectId.isValid(val), {
      message: "Invalid ObjectId format for schoolId",
    }), // Bắt buộc, kiểm tra format ObjectId
  classId: z
    .string()
    .min(1, { message: "classId is required" })
    .refine((val) => Types.ObjectId.isValid(val), {
      message: "Invalid ObjectId format for classId",
    }), // Bắt buộc, kiểm tra format ObjectId
});

export type Student = z.infer<typeof StudentSchema>;
export const CreateStudentSchema = StudentSchema.omit({ _id: true });
export const UpdateStudentSchema = StudentSchema.partial({
  fullName: true,
  roleId: true,
  gender: true,
  birthday: true,
  phone: true,
  address: true,
  isVerified: true,
  schoolId: true,
  classId: true,
});