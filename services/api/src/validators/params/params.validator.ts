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
