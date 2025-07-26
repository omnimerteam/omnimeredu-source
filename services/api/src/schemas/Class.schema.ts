import { z } from "zod";
import { Types } from "mongoose";

export const ClassSchema = z.object({
  _id: z
    .string()
    .refine((val) => Types.ObjectId.isValid(val), {
      message: "Invalid ObjectId format for _id",
    })
    .optional(), // MongoDB tự sinh
  name: z
    .string()
    .min(1, { message: "Name is required" })
    .max(100, { message: "Name cannot exceed 100 characters" }), // Bắt buộc, validate độ dài
  code: z
    .string()
    .min(1, { message: "Code is required" })
    .regex(/^[A-Z0-9-]{3,10}$/, {
      message: "Code must be 3-10 characters, containing only uppercase letters, numbers, or hyphens",
    }), // Bắt buộc, validate format
  schoolId: z
    .string()
    .min(1, { message: "schoolId is required" })
    .refine((val) => Types.ObjectId.isValid(val), {
      message: "Invalid ObjectId format for schoolId",
    }), // Bắt buộc, kiểm tra format ObjectId
  teacherId: z
    .string()
    .refine((val) => !val || Types.ObjectId.isValid(val), {
      message: "Invalid ObjectId format for teacherId",
    })
    .optional(), // Không bắt buộc, kiểm tra format nếu có
  students: z
    .array(
      z
        .string()
        .refine((val) => Types.ObjectId.isValid(val), {
          message: "Invalid ObjectId format for student in students array",
        })
    )
    .optional(), // Không bắt buộc, mảng ObjectId
  baseFee: z
    .number()
    .positive({ message: "baseFee must be a positive number" }), // Bắt buộc, số dương
});

export type Class = z.infer<typeof ClassSchema>;
export const CreateClassSchema = ClassSchema.omit({ _id: true });
export const UpdateClassSchema = ClassSchema.partial({
  name: true,
  code: true,
  schoolId: true,
  teacherId: true,
  students: true,
  baseFee: true,
});