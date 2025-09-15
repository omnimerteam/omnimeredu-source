import { z } from "zod";
import { MembershipRequestSchema } from "./membershipRequest.schema";
import { MembershipStatusTuple } from "../../../enum/membershipRequest.enum";

/**
 * 🔹 Create - tất cả trường bắt buộc trừ _id và note
 */
export const createMembershipRequestBodySchema = MembershipRequestSchema.omit({
  _id: true,
  note: true,
});

/**
 * 🔹 Update - tất cả fields optional
 */
export const updateMembershipRequestBodySchema =
  MembershipRequestSchema.partial({
    userId: true,
    schoolId: true,
    classId: true,
    role: true,
    action: true,
    status: true,
    note: true,
  });

/**
 * 🔹 Update action - chỉ validate field action
 */
export const updateStatusMembershipRequestBodySchema = z.object({
  status: z.enum(MembershipStatusTuple, {
    message: `action phải là một trong: ${MembershipStatusTuple.join(", ")}`,
  }),
});
