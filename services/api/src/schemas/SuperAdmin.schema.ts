import { z } from "zod";
import { BaseUserSchema } from "./BaseUser.schema";

// Định nghĩa schema cho SuperAdmin, kế thừa từ BaseUserSchema
export const SuperAdminSchema = BaseUserSchema;

export type SuperAdmin = z.infer<typeof SuperAdminSchema>;
