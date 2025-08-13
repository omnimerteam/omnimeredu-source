// src/schemas/activityLog.schema.ts
import { z } from "zod";
import { Types } from "mongoose";

export const ActivityLogSchema = z.object({
  _id: z
    .string()
    .refine((val) => Types.ObjectId.isValid(val), {
      message: "Định dạng ObjectId không hợp lệ cho _id",
    })
    .optional(), // MongoDB tự sinh

  userId: z
    .string()
    .min(1, { message: "userId là bắt buộc" })
    .refine((val) => Types.ObjectId.isValid(val), {
      message: "Định dạng ObjectId không hợp lệ cho userId",
    }),

  action: z.string().min(1, { message: "Action là bắt buộc" }),

  targetId: z
    .string()
    .refine((val) => !val || Types.ObjectId.isValid(val), {
      message: "Định dạng ObjectId không hợp lệ cho targetId",
    })
    .optional(),

  roleSnapshot: z.string().optional(),

  timestamp: z.string().datetime().optional(), // MongoDB tự set

  metadata: z.record(z.string(), z.any()).optional(),
});

export type ActivityLog = z.infer<typeof ActivityLogSchema>;
