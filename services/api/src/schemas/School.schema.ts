import { z } from "zod";
import { Types } from "mongoose";

// Định nghĩa enum cho level
const LevelEnum = ["Preschool", "Primary", "Secondary", "HighSchool", "University"] as const;

export const SchoolSchema = z.object({
  _id: z
    .string()
    .refine((val) => Types.ObjectId.isValid(val), {
      message: "Invalid ObjectId format for _id",
    })
    .optional(), // MongoDB tự sinh
  name: z
    .string()
    .min(1, { message: "Name is required" })
    .max(200, { message: "Name cannot exceed 200 characters" }), // Bắt buộc, validate độ dài
  code: z
    .string()
    .min(1, { message: "Code is required" })
    .regex(/^[A-Z0-9-]{3,10}$/, {
      message: "Code must be 3-10 characters, containing only uppercase letters, numbers, or hyphens",
    }), // Bắt buộc, validate format
  address: z
    .string()
    .min(10, { message: "Address must be at least 10 characters" })
    .max(500, { message: "Address cannot exceed 500 characters" }), // Bắt buộc, validate độ dài
  phone: z
    .string()
    .regex(/^\+?[0-9]{8,15}$/, {
      message: "Invalid phone number format",
    })
    .optional(), // Không bắt buộc, validate format
  description: z
    .string()
    .max(1000, { message: "Description cannot exceed 1000 characters" })
    .optional(), // Không bắt buộc, validate độ dài
  level: z.enum(LevelEnum, {
    message: `Level must be one of: ${LevelEnum.join(", ")}`,
  }), // Bắt buộc, giới hạn trong enum
  adminId: z
    .string()
    .refine((val) => !val || Types.ObjectId.isValid(val), {
      message: "Invalid ObjectId format for adminId",
    })
    .optional(), // Không bắt buộc, kiểm tra format nếu có
  logoUrl: z
    .string()
    .url({ message: "Invalid URL format for logoUrl" })
    .optional(), // Không bắt buộc, validate URL
  customTheme: z
    .record(z.string(), z.any())
    .optional(), // Không bắt buộc, validate object JSON
});

export type School = z.infer<typeof SchoolSchema>;
export const CreateSchoolSchema = SchoolSchema.omit({ _id: true });
export const UpdateSchoolSchema = SchoolSchema.partial({
  name: true,
  code: true,
  address: true,
  phone: true,
  description: true,
  level: true,
  adminId: true,
  logoUrl: true,
  customTheme: true,
});