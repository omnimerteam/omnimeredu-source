// src/validators/activityLog.validator.ts
import { z } from "zod";
import { ActivityLogSchema } from "./ActivityLog.schema";

// Regex kiểm tra ObjectId cho chắc
const objectIdRegex = /^[0-9a-fA-F]{24}$/;

// ✅ Create Log Body Schema
export const createActivityLogBodySchema = ActivityLogSchema.omit({
  _id: true,
  timestamp: true,
}).extend({
  userId: z
    .string()
    .regex(objectIdRegex, { message: "userId phải là ObjectId hợp lệ" }),
  action: z.string().min(1, { message: "Action là bắt buộc" }),
});

// ✅ Update Log Body Schema
export const updateActivityLogBodySchema = ActivityLogSchema.partial({
  userId: true,
  action: true,
  targetId: true,
  roleSnapshot: true,
  metadata: true,
}).extend({
  userId: z
    .string()
    .regex(objectIdRegex, { message: "userId phải là ObjectId hợp lệ" })
    .optional(),
  targetId: z
    .string()
    .regex(objectIdRegex, { message: "targetId phải là ObjectId hợp lệ" })
    .optional(),
});
