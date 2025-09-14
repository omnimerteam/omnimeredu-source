import { z } from "zod";
import { Types } from "mongoose";
import { AttendanceStatusTuple } from "../../../enum/attendanceStatus.enum";

export const DetailsRecordSchema = z.object({
  _id: z
    .string()
    .refine((val) => Types.ObjectId.isValid(val), {
      message: "Định dạng ObjectId không hợp lệ cho _id",
    })
    .optional(),

  studentId: z
    .string()
    .min(1, { message: "studentId là bắt buộc" })
    .refine((val) => Types.ObjectId.isValid(val), {
      message: "Định dạng ObjectId không hợp lệ cho studentId",
    }),

  attendanceId: z
    .string()
    .min(1, { message: "attendanceId là bắt buộc" })
    .refine((val) => Types.ObjectId.isValid(val), {
      message: "Định dạng ObjectId không hợp lệ cho attendanceId",
    }),

  status: z.enum(AttendanceStatusTuple, {
    message: `Trạng thái phải là một trong: ${AttendanceStatusTuple.join(
      ", "
    )}`,
  }),

  note: z
    .string()
    .max(500, { message: "Ghi chú không được vượt quá 500 ký tự" })
    .optional(),
});

export type DetailsRecord = z.infer<typeof DetailsRecordSchema>;
