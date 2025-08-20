// ======================
// User Module
// ======================
export * as AccountRepository from "./user/account.repository";
export * as BaseUserRepository from "./user/basedUser.repository";
export { default as SchoolAdminRepository } from "./user/schoolAdmin.repository";
export { default as SuperAdminRepository } from "./user/superAdmin.repository";
export { default as TeacherRepository } from "./user/teacher.repository";
export { default as StudentRepository } from "./user/student.repository";
export { default as RoleRepository } from "./user/role.repository";

// ======================
// School Module
// ======================
export { default as SchoolRepository } from "./school/school.repository";
export { default as NewsRepository } from "./school/news.repository";

export { default as ClassRepository } from "./school/class/class.repository";
export { default as TeachingAssignmentRepository } from "./school/class/teachingAssignment.repository";

export { default as AttendanceRepository } from "./school/attendance/attendance.repository";
export { default as DetailsRecordRepository } from "./school/attendance/detailsRecord.repository";

// ======================
// Payment Module
// ======================

// ======================
// System Module
// ======================
export { default as ActivityLogRepository } from "./system/activityLog.repository";
