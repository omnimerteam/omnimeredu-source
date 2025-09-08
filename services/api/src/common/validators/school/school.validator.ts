import { SchoolSchema } from "./School.schema";

// Schema tạo mới
export const createSchoolBodySchema = SchoolSchema.omit({
  _id: true,
  studentCount: true,
  code: true,
  customTheme: true,
});

// Schema cập nhật
export const updateSchoolBodySchema = SchoolSchema.partial({
  name: true,
  code: true,
  address: true,
  phone: true,
  description: true,
  level: true,
  adminId: true,
  logoUrl: true,
  customTheme: true,
});
