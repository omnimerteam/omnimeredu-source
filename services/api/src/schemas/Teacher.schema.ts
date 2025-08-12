import { z } from "zod";
import { BaseUserSchema } from "./BaseUser.schema";

// Schema cho Teacher kế thừa từ BaseUserSchema
export const TeacherSchema = BaseUserSchema.extend({
  literacy: z
    .string()
    .max(200, { message: "Trình độ học vấn không được vượt quá 200 ký tự" })
    .optional(),
  subjects: z
    .array(
      z
        .string()
        .max(100, { message: "Mỗi môn học không được vượt quá 100 ký tự" })
    )
    .optional(),
});

export type Teacher = z.infer<typeof TeacherSchema>;
