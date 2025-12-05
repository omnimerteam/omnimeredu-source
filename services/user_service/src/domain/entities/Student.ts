import { User } from "./User";
import {
  GenderEnum,
  RoleGroup,
  EducationSystemLevelsEnum,
  EducationGradesEnum,
} from "shared-lib";

export class Student extends User {
  constructor(
    id: string,
    fullName: string,
    email: string | undefined,
    gender: GenderEnum | undefined,
    birthday: Date | undefined,
    phone: string | undefined,
    address: string | undefined,
    isVerified: boolean,
    avatarUrl: string | undefined,
    schoolId: string | null | undefined,
    deletedAt: Date | null | undefined,

    // Student specific fields
    public educationLevel: EducationSystemLevelsEnum,
    public gradeGroup: EducationGradesEnum,
    public classId?: string | null,
    public guardianName?: string,
    public guardianPhone?: string,
    public meta?: Record<string, any>
  ) {
    super(
      id,
      fullName,
      RoleGroup.Student,
      email,
      gender,
      birthday,
      phone,
      address,
      isVerified,
      avatarUrl,
      schoolId,
      deletedAt
    );
  }
}
