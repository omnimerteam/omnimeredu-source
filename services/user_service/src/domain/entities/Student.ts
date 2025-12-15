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
      email || "", // Email

      // --- SỬA TẠI ĐÂY: THÊM PASSWORD ---
      "", // Thêm chuỗi rỗng vào đây để làm placeholder cho 'password' (nếu User yêu cầu)
      // ----------------------------------

      gender, // Bây giờ gender mới rơi đúng vào ô GenderEnum

      birthday || new Date(), // Bây giờ birthday mới rơi đúng vào ô Date

      phone || "",
      address || "",
      isVerified,
      avatarUrl,
      schoolId || null,
      deletedAt || null
    );
  }
}