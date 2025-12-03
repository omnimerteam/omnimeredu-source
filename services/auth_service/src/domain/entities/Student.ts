import { User, RoleGroup, Gender } from "./User";

export enum EducationSystemLevels {
  Primary = "Primary",
  Secondary = "Secondary",
  HighSchool = "HighSchool",
  University = "University",
}

export enum EducationGrades {
  Grade1 = "Grade1",
  Grade2 = "Grade2",
  Grade10 = "Grade10",
  Grade11 = "Grade11",
  Grade12 = "Grade12",
  // Add others as needed
}

export class Student extends User {
  constructor(
    id: string,
    fullName: string,
    email: string | undefined,
    gender: Gender | undefined,
    birthday: Date | undefined,
    phone: string | undefined,
    address: string | undefined,
    isVerified: boolean,
    avatarUrl: string | undefined,
    schoolId: string | null | undefined,
    deletedAt: Date | null | undefined,

    // Student specific fields
    public educationLevel: EducationSystemLevels,
    public gradeGroup: EducationGrades,
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
