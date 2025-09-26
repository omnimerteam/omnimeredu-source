import { z } from "zod";
import { Types } from "mongoose";
import { RoleGroupTuple, RoleTuple } from "../../../enum/role.enum";

export const RoleSchema = z.object({
  _id: z
    .string()
    .refine((val) => Types.ObjectId.isValid(val), {
      message: "Định dạng ObjectId không hợp lệ cho _id",
    })
    .optional(), // MongoDB tự sinh

  name: z.enum(RoleTuple, {
    message: "Vai trò này không nằm trong hệ thống",
  }),

  group: z.enum(RoleGroupTuple, {
    message: "Nhóm này không nằm trong hệ thống",
  }),

  description: z
    .string()
    .max(500, { message: "Mô tả không được vượt quá 500 ký tự" })
    .optional(),

  permissions: z
    .array(
      z
        .string()
        .max(100, { message: "Mỗi quyền không được vượt quá 100 ký tự" })
    )
    .optional(),
});

export type Role = z.infer<typeof RoleSchema>;
