import { z } from "zod";
import { Types } from "mongoose";

// Định nghĩa danh sách action (enum)
const ActionEnum = [
  "createUser",
  "updateUser",
  "deleteUser",
  "createClass",
  "updateClass",
  "deleteClass",
  "createStudent",
  "updateStudent",
  "deleteStudent",
  "createTeacher",
  "updateTeacher",
  "deleteTeacher",
  "login",
  "logout",
  "updateSchool",
  "createPayment",
  "updatePayment",
] as const;

// Định nghĩa danh sách role (giả định)
const RoleEnum = ["SchoolAdmin", "Teacher", "Student", "SystemAdmin"] as const;

export const ActivityLogSchema = z.object({
  _id: z
    .string()
    .refine((val) => Types.ObjectId.isValid(val), {
      message: "Invalid ObjectId format for _id",
    })
    .optional(), // MongoDB tự sinh
  userId: z
    .string()
    .min(1, { message: "userId is required" })
    .refine((val) => Types.ObjectId.isValid(val), {
      message: "Invalid ObjectId format for userId",
    }), // Bắt buộc, kiểm tra format ObjectId
  action: z.enum(ActionEnum).refine((val) => ActionEnum.includes(val), {
    message: `Action must be one of: ${ActionEnum.join(", ")}`,
  }), // Bắt buộc, giới hạn trong danh sách action
  targetId: z
    .string()
    .refine((val) => !val || Types.ObjectId.isValid(val), {
      message: "Invalid ObjectId format for targetId",
    })
    .optional(), // Không bắt buộc, kiểm tra format nếu có
  roleSnapshot: z
    .enum(RoleEnum)
    .optional()
    .refine((val) => !val || RoleEnum.includes(val), {
      message: `Role must be one of: ${RoleEnum.join(", ")}`,
    }), // Không bắt buộc, giới hạn trong danh sách role
  timestamp: z
    .string()
    .datetime({ message: "Invalid date format for timestamp" })
    .optional(), // MongoDB tự set
  metadata: z.record(z.string(), z.any()).optional(), // Không bắt buộc, JSON object
});

export type ActivityLog = z.infer<typeof ActivityLogSchema>;
export const CreateActivityLogSchema = ActivityLogSchema.omit({ _id: true, timestamp: true });
export const UpdateActivityLogSchema = ActivityLogSchema.partial({
  userId: true,
  action: true,
  targetId: true,
  roleSnapshot: true,
  metadata: true,
});