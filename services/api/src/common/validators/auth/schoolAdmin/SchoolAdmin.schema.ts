import { z } from "zod";
import { BaseUserSchema } from "../baseUser/BaseUser.schema";
import { SchoolAdminPositionTuple } from "../../../enum/schoolAdmin.enum";

// Schema gốc cho SchoolAdmin (chỉ định nghĩa field & kiểu)
export const SchoolAdminSchema = BaseUserSchema.extend({
  position: z
    .enum(SchoolAdminPositionTuple, {
      message: `Cấp học phải thuộc một trong các giá trị:
      `,
    })
    .nullable()
    .optional(),
});

export type SchoolAdmin = z.infer<typeof SchoolAdminSchema>;
