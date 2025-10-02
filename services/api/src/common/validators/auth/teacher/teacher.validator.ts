import { TeacherSchema } from "./Teacher.schema";

// Schema khi tạo mới Teacher (bỏ _id)
export const createTeacherBodySchema = TeacherSchema.omit({
  _id: true,
  schoolId: true,
});

// Schema khi cập nhật Teacher (tất cả các trường optional)
export const updateTeacherBodySchema = TeacherSchema.partial({});
