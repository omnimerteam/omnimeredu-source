import { z } from "zod";
import { BaseUserSchema } from "../baseUser/BaseUser.schema";

// Schema gốc cho SchoolAdmin (chỉ định nghĩa field & kiểu)
export const SchoolAdminSchema = BaseUserSchema.extend({
  position: z
    .string()
    .min(1, { message: "Vị trí công việc là bắt buộc" })
    .max(100, { message: "Tên vị trí tối đa là 100 ký tự" })
    .optional(),
});

export type SchoolAdmin = z.infer<typeof SchoolAdminSchema>;
