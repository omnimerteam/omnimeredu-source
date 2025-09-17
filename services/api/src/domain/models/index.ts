// ======================
// User Module
// ======================
export { default as Account, IAccount } from "./user/Account";
export { default as BaseUser, IBaseUser } from "./user/BaseUser";
export { default as Student, IStudent } from "./user/Student";
export { default as Teacher, ITeacher } from "./user/Teacher";
export { default as SchoolAdmin, ISchoolAdmin } from "./user/SchoolAdmin";
export { default as SuperAdmin, ISuperAdmin } from "./user/SuperAdmin";
export { default as Role, IRole } from "./user/Role";

// ======================
// School Module
// ======================
export { default as School, ISchool } from "./school/School";
export { default as News, INews } from "./school/News";
export {
  default as MembershipRequest,
  IMembershipRequest,
} from "./school/MembershipRequest";
export { default as Grade, IGrade } from "./school/Grade";

// Class
export { default as Class, IClass } from "./school/class/Class";
export {
  default as TeachingAssignment,
  ITeachingAssignment,
} from "./school/class/TeachingAssignment";

// Attendance
export {
  default as Attendance,
  IAttendance,
} from "./school/attendance/Attendance";
export {
  default as DetailsRecord,
  IDetailsRecord,
} from "./school/attendance/DetailsRecord";

// Tuition
export { default as Tuition, ITuition } from "./school/tuition/Tuition";
export {
  default as DiscountPolicy,
  IDiscountPolicy,
} from "./school/tuition/DiscountPolicy";
export { default as ExtraFee, IExtraFee } from "./school/tuition/ExtraFee";

// ======================
// Payment Module
// ======================
export {
  default as TuitionInvoice,
  ITuitionInvoice,
} from "./payment/TuitionInvoice";
export { default as VipInvoice, IVipInvoice } from "./payment/VipInvoice";
export {
  default as PaymentMethod,
  IPaymentMethod,
} from "./payment/PaymentMethod";

// ======================
// System Module
// ======================
export { default as ActivityLog, IActivityLog } from "./system/ActivityLog";
export {
  default as SchoolSubscription,
  ISchoolSubscription,
} from "./system/SchoolSubscription";
export { default as VipPackage, IVipPackage } from "./system/VipPackage";
export { default as Notification, INotification } from "./system/Notification";

// ======================
// View Model
// ======================
export {
  default as ClassDetailView,
  IClassDetailView,
} from "./viewModel/ClassDetail";
