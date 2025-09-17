import { z } from "zod";
import { BaseUserSchema } from "../baseUser/BaseUser.schema";
import {
  SubjectTuple,
  TeacherQualificationTuple,
} from "../../../enum/teacher.enum";

// Schema cho Teacher kế thừa từ BaseUserSchema
export const TeacherSchema = BaseUserSchema.extend({
  /**
   * Trình độ học vấn của giáo viên (enum)
   */
  qualification: z
    .enum([...TeacherQualificationTuple] as [string, ...string[]])
    .optional(),

  /**
   * Các môn mà giáo viên giảng dạy (enum array)
   */
  subjects: z
    .array(z.enum([...SubjectTuple] as [string, ...string[]]))
    .optional(),
});

export type Teacher = z.infer<typeof TeacherSchema>;
