// ======================
// User Module
// ======================
export { default as AuthController } from "./user/auth.controller";
export { default as SchoolAdminController } from "./user/schoolAdmin.controller";
export { default as SuperAdminController } from "./user/superAdmin.controller";
export { default as TeacherController } from "./user/teacher.controller";
export { default as StudentController } from "./user/student.controller";
export { default as RoleController } from "./user/role.controller";

// ======================
// School Module
// ======================
export { default as SchoolController } from "./school/school.controller";
export { default as NewsController } from "./school/news.controller";
export { default as MembershipRequestController } from "./school/membershipRequest.controller";
export { default as GradeController } from "./school/grade.controller";

export { default as ClassController } from "./school/class/class.controller";
export { default as TeachingAssignmentController } from "./school/class/teachingAssignment.controller";

export { default as AttendanceController } from "./school/attendance/attendance.controller";
export { default as DetailsRecordController } from "./school/attendance/detailsRecord.controller";

// ======================
// Payment Module
// ======================

// ======================
// System Module
// ======================
export { default as VipPackageController } from "./system/vipPackage.controller";

// ======================
// SchoolAdmin Dashboard Module
// ======================
export { default as SchoolAdminDashboardController } from "./schoolAdminDashboard/schoolAdminDashboard.controller";
