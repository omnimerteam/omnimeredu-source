// ======================
// User Module
// ======================
export { default as AuthService } from "./user/auth.service";
export { default as SchoolAdminService } from "./user/schoolAdmin.service";
export { default as SuperAdminService } from "./user/superAdmin.service";
export { default as TeacherService } from "./user/teacher.service";
export { default as StudentService } from "./user/student.service";
export { default as RoleService } from "./user/role.service";
// ======================
// School Module
// ======================
export { default as SchoolService } from "./school/school.service";
export { default as NewsService } from "./school/news.service";
export { default as MembershipRequestService } from "./school/membershipRequest.service";

export { default as ClassService } from "./school/class/class.service";
export { default as TeachingAssignmentService } from "./school/class/teachingAssignment.service";

export { default as AttendanceService } from "./school/attendance/attendance.service";
export { default as DetailsRecordService } from "./school/attendance/detailsRecord.service";

// ======================
// Payment Module
// ======================

// ======================
// System Module
// ======================
export { default as VipPackageService } from "./system/vipPackage.service";

// ======================
// System Module
// ======================
export { default as SchoolAdminDashboardService } from "./schoolAdminDashboard/schoolAdminDashboard.service";
