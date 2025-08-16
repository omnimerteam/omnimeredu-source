// src/utils/roleValidatorMap.ts
import { createTeacherBodySchema } from "../validators/teacher/teacher.validator";
import { createStudentBodySchema } from "../validators/student/student.validator";
import { createSchoolAdminBodySchema } from "../validators/schoolAdmin/schoolAdmin.validator";
import { createSuperAdminSchema } from "../validators/superAdmin/superAdmin.validator";
import { createBaseUserBodySchema } from "../validators/baseUser.validator";

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
