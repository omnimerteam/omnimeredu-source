import { z } from "zod";
import { Types } from "mongoose";
import { BaseUserSchema } from "./BaseUser.schema";

// Định nghĩa schema cho SchoolAdmin, kế thừa từ BaseUserSchema
export const SchoolAdminSchema = BaseUserSchema.extend({
  schoolId: z
    .string()
    .min(1, { message: "schoolId is required" })
    .refine((val) => Types.ObjectId.isValid(val), {
      message: "Invalid ObjectId format for schoolId",
    }), // Bắt buộc, kiểm tra format ObjectId
});

export type SchoolAdmin = z.infer<typeof SchoolAdminSchema>;
export const CreateSchoolAdminSchema = SchoolAdminSchema.omit({ _id: true });
export const UpdateSchoolAdminSchema = SchoolAdminSchema.partial({
  fullName: true,
  roleId: true,
  gender: true,
  birthday: true,
  phone: true,
  address: true,
  isVerified: true,
  schoolId: true,
});