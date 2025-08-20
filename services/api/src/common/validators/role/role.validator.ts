import { z } from "zod";
import { RoleSchema } from "./Role.schema";

// Schema tạo mới
export const createRoleBodySchema = RoleSchema.omit({ _id: true }).extend({
  name: RoleSchema.shape.name,
  description: RoleSchema.shape.description,
  permissions: RoleSchema.shape.permissions,
});

// Schema cập nhật
export const updateRoleBodySchema = RoleSchema.partial({
  name: true,
  description: true,
  permissions: true,
}).extend({
  name: RoleSchema.shape.name.optional(),
  description: RoleSchema.shape.description.optional(),
  permissions: RoleSchema.shape.permissions.optional(),
});
