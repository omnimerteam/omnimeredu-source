import { z } from "zod";
import { BaseUserSchema } from "./BaseUser.schema";

// Định nghĩa schema cho SuperAdmin, kế thừa từ BaseUserSchema
export const SuperAdminSchema = BaseUserSchema;

export type SuperAdmin = z.infer<typeof SuperAdminSchema>;
export const CreateSuperAdminSchema = SuperAdminSchema.omit({ _id: true });
export const UpdateSuperAdminSchema = SuperAdminSchema.partial({
  fullName: true,
  roleId: true,
  gender: true,
  birthday: true,
  phone: true,
  address: true,
  isVerified: true,
});