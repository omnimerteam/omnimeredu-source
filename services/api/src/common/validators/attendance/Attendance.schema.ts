// src/schemas/attendance.schema.ts
import { z } from "zod";
import { Types } from "mongoose";

export const AttendanceSchema = z.object({
  _id: z
    .string()
    .refine((val) => Types.ObjectId.isValid(val), {
      message: "Định dạng ObjectId không hợp lệ cho _id",
    })
    .optional(), // MongoDB tự sinh

  classId: z.string().refine((val) => Types.ObjectId.isValid(val), {
    message: "Định dạng ObjectId không hợp lệ cho classId",
  }),

  date: z.string().datetime({
    message: "Ngày phải đúng định dạng",
  }),

  students: z
    .array(
      z.object({
        studentId: z.string().refine((val) => Types.ObjectId.isValid(val), {
          message: "Định dạng ObjectId không hợp lệ cho studentId",
        }),
        status: z.enum(["present", "absent", "late"], {
          message: "Trạng thái điểm danh không đúng",
        }),
      })
    )
    .optional(),
});

export type Attendance = z.infer<typeof AttendanceSchema>;
