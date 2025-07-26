import { z } from "zod";
import { Types } from "mongoose";

// Định nghĩa enum cho status
const StatusEnum = ["Present", "AbsentWithLeave", "Absent"] as const;

export const DetailsRecordSchema = z.object({
  _id: z
    .string()
    .refine((val) => Types.ObjectId.isValid(val), {
      message: "Invalid ObjectId format for _id",
    })
    .optional(), // MongoDB tự sinh
  studentId: z
    .string()
    .min(1, { message: "studentId is required" })
    .refine((val) => Types.ObjectId.isValid(val), {
      message: "Invalid ObjectId format for studentId",
    }), // Bắt buộc, kiểm tra format ObjectId
  attendanceId: z
    .string()
    .min(1, { message: "attendanceId is required" })
    .refine((val) => Types.ObjectId.isValid(val), {
      message: "Invalid ObjectId format for attendanceId",
    }), // Bắt buộc, kiểm tra format ObjectId
  status: z
    .enum(StatusEnum)
    .refine((val) => StatusEnum.includes(val), {
      message: `Status must be one of: ${StatusEnum.join(", ")}`,
    }), // Bắt buộc, giới hạn trong enum
  note: z
    .string()
    .max(500, { message: "Note cannot exceed 500 characters" })
    .optional(), // Không bắt buộc, validate độ dài
});

export type DetailsRecord = z.infer<typeof DetailsRecordSchema>;
export const CreateDetailsRecordSchema = DetailsRecordSchema.omit({ _id: true });
export const UpdateDetailsRecordSchema = DetailsRecordSchema.partial({
  studentId: true,
  attendanceId: true,
  status: true,
  note: true,
});