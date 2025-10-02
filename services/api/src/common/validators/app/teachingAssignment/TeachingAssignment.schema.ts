import { z } from "zod";
import { Types } from "mongoose";
import { SubjectTuple } from "../../../enum/teacher.enum";

// Định nghĩa schema cho TeachingAssignment
export const TeachingAssignmentSchema = z.object({
  _id: z
    .string()
    .refine((val) => Types.ObjectId.isValid(val), {
      message: "Định dạng không hợp lệ cho _id",
    })
    .optional(),
  teacherId: z
    .string()
    .min(1, { message: "teacherId là bắt buộc" })
    .refine((val) => Types.ObjectId.isValid(val), {
      message: "Định dạng không hợp lệ cho teacherId",
    }),
  classId: z
    .string()
    .min(1, { message: "classId là bắt buộc" })
    .refine((val) => Types.ObjectId.isValid(val), {
      message: "Định dạng không hợp lệ cho classId",
    }),
  schoolId: z
    .string()
    .min(1, { message: "SchoolId là bắt buộc" })
    .refine((val) => Types.ObjectId.isValid(val), {
      message: "Định dạng không hợp lệ cho SchoolId",
    }),
  subject: z
    .enum(SubjectTuple, { message: "Môn học không nằm trong hệ thống" })
    .optional()
    .nullable(),
  isMain: z.boolean().optional(),
});

export type TeachingAssignment = z.infer<typeof TeachingAssignmentSchema>;
