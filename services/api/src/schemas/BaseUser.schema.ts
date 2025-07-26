import { z } from "zod";
import { Types } from "mongoose";

// Định nghĩa enum cho gender
const GenderEnum = ["Male", "Female", "Other"] as const;

export const BaseUserSchema = z.object({
  _id: z
    .string()
    .refine((val) => Types.ObjectId.isValid(val), {
      message: "Invalid ObjectId format for _id",
    })
    .optional(), // MongoDB tự sinh
  fullName: z
    .string()
    .min(2, { message: "Full name must be at least 2 characters" })
    .max(100, { message: "Full name cannot exceed 100 characters" })
    .regex(/^[a-zA-Z\s\u00C0-\u1EF9]*$/, {
      message: "Full name can only contain letters and spaces",
    }), // Bắt buộc, validate độ dài và ký tự
  roleId: z
    .string()
    .min(1, { message: "roleId is required" })
    .refine((val) => Types.ObjectId.isValid(val), {
      message: "Invalid ObjectId format for roleId",
    }), // Bắt buộc, kiểm tra format ObjectId
  gender: z.enum(GenderEnum).optional(), // Không bắt buộc, giới hạn trong enum
  birthday: z
    .string()
    .datetime({ message: "Invalid date format for birthday" })
    .refine((val) => !val || new Date(val) <= new Date(), {
      message: "Birthday cannot be in the future",
    })
    .optional(), // Không bắt buộc, không tương lai
  phone: z
    .string()
    .regex(/^(?:\+84|0)(?:\d{9,10})$/, {
      message: "Invalid phone number format (e.g., +84987654321 or 0987654321)",
    })
    .optional(), // Không bắt buộc, validate format
  address: z
    .string()
    .max(500, { message: "Address cannot exceed 500 characters" })
    .optional(), // Không bắt buộc, validate độ dài
  isVerified: z.boolean().optional(), // Không bắt buộc, boolean
});

export type BaseUser = z.infer<typeof BaseUserSchema>;
export const CreateBaseUserSchema = BaseUserSchema.omit({ _id: true });
export const UpdateBaseUserSchema = BaseUserSchema.partial({
  fullName: true,
  roleId: true,
  gender: true,
  birthday: true,
  phone: true,
  address: true,
  isVerified: true,
});