import { z } from "zod";
import { Types } from "mongoose";
import {
  MembershipActionTuple,
  MembershipRoleTuple,
  MembershipStatusEnum,
  MembershipStatusTuple,
} from "../../../enum/membershipRequest.enum";

/**
 * 🔹 Schema cơ bản cho MembershipRequest
 */
export const MembershipRequestSchema = z.object({
  _id: z
    .string()
    .refine((val) => Types.ObjectId.isValid(val), {
      message: "Định dạng ObjectId không hợp lệ cho _id",
    })
    .optional(),

  userId: z
    .string()
    .min(1, { message: "userId là bắt buộc" })
    .refine((val) => Types.ObjectId.isValid(val), {
      message: "Định dạng ObjectId không hợp lệ cho userId",
    }),

  schoolId: z
    .string()
    .min(1, { message: "schoolId là bắt buộc" })
    .refine((val) => Types.ObjectId.isValid(val), {
      message: "Định dạng ObjectId không hợp lệ cho schoolId",
    }),

  classId: z
    .string()
    .optional()
    .refine((val) => !val || Types.ObjectId.isValid(val), {
      message: "Định dạng ObjectId không hợp lệ cho classId",
    }),

  role: z.enum(MembershipRoleTuple, {
    message: `role phải là một trong: ${MembershipRoleTuple.join(", ")}`,
  }),

  action: z.enum(MembershipActionTuple, {
    message: `action phải là một trong: ${MembershipActionTuple.join(", ")}`,
  }),

  status: z
    .enum(MembershipStatusTuple)
    .optional()
    .default(MembershipStatusEnum.Pending),

  note: z
    .string()
    .max(500, { message: "Ghi chú không được vượt quá 500 ký tự" })
    .optional(),
});

export type MembershipRequestType = z.infer<typeof MembershipRequestSchema>;
