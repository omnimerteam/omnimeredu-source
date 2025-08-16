import { z } from "zod";
import { AccountSchema } from "../account/Account.schema";
import { BaseUserSchema } from "../baseUser/BaseUser.schema";
import { SchoolAdminSchema } from "../schoolAdmin/SchoolAdmin.schema";

// Common fields cho account khi register (uid sẽ sinh bên Firebase nên bỏ ra)
const RegisterAccountSchema = AccountSchema.pick({
  email: true,
  password: true,
})
  .extend({
    confirmPassword: z.string().min(6, "Xác nhận mật khẩu tối thiểu 6 ký tự"),
  })
  .refine((data) => data.password === data.confirmPassword, {
    message: "Mật khẩu xác nhận không khớp",
    path: ["confirmPassword"],
  });

// Base info chung cho tất cả user
const RegisterBaseUserSchema = BaseUserSchema.pick({
  fullName: true,
  roleId: true,
  gender: true,
  phone: true,
  birthday: true,
  address: true,
});

// Schema cho từng loại role (ví dụ SchoolAdmin)
const RegisterSchoolAdminSchema = SchoolAdminSchema.pick({
  schoolId: true,
});

// Schema tổng hợp cho register
export const AuthRegisterSchema = RegisterAccountSchema.merge(
  RegisterBaseUserSchema
)
  .merge(RegisterSchoolAdminSchema) // nếu muốn bắt buộc schoolId khi role là SchoolAdmin
  .extend({
    roleName: z.enum(["SchoolAdmin", "Teacher", "Student"], {
      message: "Role không hợp lệ",
    }),
  });

export type AuthRegisterInput = z.infer<typeof AuthRegisterSchema>;
