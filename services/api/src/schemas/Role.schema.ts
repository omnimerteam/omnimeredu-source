import { z } from "zod";
import { Types } from "mongoose";

// Định nghĩa enum cho name
const NameEnum = [
  "SuperAdmin",
  "SchoolAdmin",
  "Teacher",
  "Student",
  "CanteenStaff",
  "Nurse",
  "Security",
] as const;

export const RoleSchema = z.object({
  _id: z
    .string()
    .refine((val) => Types.ObjectId.isValid(val), {
      message: "Invalid ObjectId format for _id",
    })
    .optional(), // MongoDB tự sinh
  name: z.enum(NameEnum, {
    message: `Name must be one of: ${NameEnum.join(", ")}`,
  }), // Bắt buộc, giới hạn trong enum
  description: z
    .string()
    .max(500, { message: "Description cannot exceed 500 characters" })
    .optional(), // Không bắt buộc, validate độ dài
  permissions: z
    .array(z.string().max(100, { message: "Each permission cannot exceed 100 characters" }))
    .optional(), // Không bắt buộc, mảng chuỗi
});

export type Role = z.infer<typeof RoleSchema>;
export const CreateRoleSchema = RoleSchema.omit({ _id: true });
export const UpdateRoleSchema = RoleSchema.partial({
  name: true,
  description: true,
  permissions: true,
});