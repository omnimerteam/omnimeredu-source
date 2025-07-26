import { z } from "zod";
import { Types } from "mongoose";

export const AttendanceSchema = z.object({
  _id: z
    .string()
    .refine((val) => Types.ObjectId.isValid(val), {
      message: "Invalid ObjectId format for _id",
    })
    .optional(), // MongoDB tự sinh
  classId: z
    .string()
    .min(1, { message: "classId is required" })
    .refine((val) => Types.ObjectId.isValid(val), {
      message: "Invalid ObjectId format for classId",
    }), // Bắt buộc, kiểm tra format ObjectId
  date: z
    .string()
    .datetime({ message: "Invalid date format for date" })
    .refine((val) => new Date(val) <= new Date(), {
      message: "Date cannot be in the future",
    }), // Bắt buộc, không được là ngày tương lai
});

export type Attendance = z.infer<typeof AttendanceSchema>;
export const CreateAttendanceSchema = AttendanceSchema.omit({ _id: true });
export const UpdateAttendanceSchema = AttendanceSchema.partial({
  classId: true,
  date: true,
});