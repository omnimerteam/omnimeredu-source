import { z } from "zod";
import { Types } from "mongoose";

export const ClassSchema = z.object({
  _id: z
    .string()
    .refine((val) => Types.ObjectId.isValid(val), {
      message: "Định dạng ObjectId không hợp lệ cho _id",
    })
    .optional(), // MongoDB tự sinh

  name: z
    .string()
    .min(1, { message: "Tên lớp là bắt buộc" })
    .max(100, { message: "Tên lớp không vượt quá 100 ký tự" }),

  code: z
    .string()
    .min(1, { message: "Mã lớp là bắt buộc" })
    .regex(/^[A-Z0-9-]{3,10}$/, {
      message: "Mã lớp phải từ 3-10 ký tự in hoa, số hoặc dấu gạch ngang",
    }),

  schoolId: z
    .string()
    .refine((val) => Types.ObjectId.isValid(val), {
      message: "Định dạng ObjectId không hợp lệ cho schoolId",
    })
    .optional(),

  gradeId: z
    .string()
    .refine((val) => Types.ObjectId.isValid(val), {
      message: "Định dạng ObjectId không hợp lệ cho gradeId",
    })
    .optional(),

  maxStudents: z.number().optional(),

  students: z
    .array(
      z.string().refine((val) => Types.ObjectId.isValid(val), {
        message: "Định dạng ObjectId không hợp lệ cho học sinh trong danh sách",
      })
    )
    .optional(),

  baseFee: z.number().positive({ message: "Học phí cơ bản phải là số dương" }),
});

export type Class = z.infer<typeof ClassSchema>;
