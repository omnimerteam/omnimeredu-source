// src/utils/roleValidatorMap.ts
import { createTeacherBodySchema } from "../validators/teacher.validator";
import { createStudentBodySchema } from "../validators/student.validator";
import { createSchoolAdminBodySchema } from "../validators/schoolAdmin.validator";
import { createSuperAdminSchema } from "../validators/superAdmin.validator";
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
