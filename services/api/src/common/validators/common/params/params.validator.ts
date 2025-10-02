import { z } from "zod";
import { Types } from "mongoose";

/**
 * Common ObjectId validator for params
 * Example: /users/:id
 */
export const objectIdParamSchema = z.object({
  id: z.string().refine((val) => Types.ObjectId.isValid(val), {
    message: "Invalid ObjectId format",
  }),
});

/**
 * School-specific params
 * Example: /classes/:schoolId
 */
export const schoolIdParamSchema = z.object({
  schoolId: z.string().refine((val) => Types.ObjectId.isValid(val), {
    message: "Invalid SchoolId format",
  }),
});

/**
 * Class-specific params
 * Example: /classes/:classId
 */
export const classIdParamSchema = z.object({
  classId: z.string().refine((val) => Types.ObjectId.isValid(val), {
    message: "Invalid ClassId format",
  }),
});

/**
 * User-specific params
 * Example: /users/:userId
 */
export const userIdParamSchema = z.object({
  userId: z.string().refine((val) => Types.ObjectId.isValid(val), {
    message: "Invalid UserId format",
  }),
});

/**
 * Generic multiple params (when multiple IDs are present)
 * Example: /schools/:schoolId/classes/:classId
 */
export const schoolAndClassParamsSchema = z.object({
  schoolId: z.string().refine((val) => Types.ObjectId.isValid(val), {
    message: "Invalid SchoolId format",
  }),
  classId: z.string().refine((val) => Types.ObjectId.isValid(val), {
    message: "Invalid ClassId format",
  }),
});

export const teacherParamsSchema = z.object({
  teacherId: z.string().refine((val) => Types.ObjectId.isValid(val), {
    message: "Invalid SchoolId format",
  }),
});

export const teacherAndSchoolParamsSchema = z.object({
  teacherId: z.string().refine((val) => Types.ObjectId.isValid(val), {
    message: "Invalid TeacherId format",
  }),
  schoolId: z.string().refine((val) => Types.ObjectId.isValid(val), {
    message: "Invalid SchoolId format",
  }),
  classId: z
    .string()
    .refine((val) => Types.ObjectId.isValid(val), {
      message: "Invalid ClassId format",
    })
    .optional(),
});

export const attendanceIdSchema = z.object({
  attendanceId: z.string().refine((val) => Types.ObjectId.isValid(val), {
    message: "Invalid AttendanceId format",
  }),
});
