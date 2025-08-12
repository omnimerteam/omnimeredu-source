import { TeacherSchema } from "../schemas/Teacher.schema";

// Schema khi tạo mới Teacher (bỏ _id)
export const createTeacherBodySchema = TeacherSchema.omit({ _id: true });

// Schema khi cập nhật Teacher (tất cả các trường optional)
export const updateTeacherBodySchema = TeacherSchema.partial({
  fullName: true,
  roleId: true,
  gender: true,
  birthday: true,
  phone: true,
  address: true,
  isVerified: true,
  literacy: true,
  subjects: true,
  schoolId: true,
});
