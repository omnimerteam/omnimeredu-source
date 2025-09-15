// src/utils/roleValidatorMap.ts
import { createTeacherBodySchema } from "../validators/auth/teacher/teacher.validator";
import { createStudentBodySchema } from "../validators/auth/student/student.validator";
import { createSchoolAdminBodySchema } from "../validators/auth/schoolAdmin/schoolAdmin.validator";
import { createSuperAdminSchema } from "../validators/auth/superAdmin/superAdmin.validator";
import { createBaseUserBodySchema } from "../validators/auth/baseUser/baseUser.validator";

export const roleValidatorMap: Record<string, any> = {
  Teacher: createTeacherBodySchema,
  Student: createStudentBodySchema,
  SchoolAdmin: createSchoolAdminBodySchema,
  SuperAdmin: createSuperAdminSchema,
};

/**
 * Lấy validator tương ứng role
 */
export const getRoleValidator = (roleName: string) => {
  const validator = roleValidatorMap[roleName];

  return validator || createBaseUserBodySchema;
};
