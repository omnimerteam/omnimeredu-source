import indexRoutes from "./index";
import schoolRouter from "./school.route";
import authRoutes from "./auth.route";
import authJwtRoutes from "./authJwt.route";
import classRoutes from "./class.route";
import teacherRoutes from "./teacher.route";
import teachingAssignment from "./teachingAssignment.route";
import schoolAdmin from "./schoolAdmin.route";
import attendance from "./attendance.route";
import detailsRecord from "./detailsRecord.route";
import newsRoute from "./news.route";
import studentRoute from "./student.route";
import vipPackageRoute from "./vipPackage.route";
import discountPolicy from "./discountPolicy.route";
import extraFee from "./extraFee.route";
import roleRoute from "./role.route";
import schoolAdminDashboardRoute from "./schoolAdminDashboard.route";
import membershipRequestRoute from "./membershipRequest.route";
import gradeRoute from "./grade.route";
import personnelRoute from "./personnel.route";
import uploadRoute from "./upload.route";

import { Express } from "express";

function setupRoutes(app: Express) {
  app.use("/", indexRoutes); // Root:/
  app.use("/api/v1/auth", authRoutes); // Auth API (Firebase): /api/v1/auth
  app.use("/api/v1/auth-jwt", authJwtRoutes); // Auth JWT API: /api/v1/auth-jwt
  app.use("/api/v1/schools", schoolRouter); // School API: /api/schools
  app.use("/api/v1/teachers", teacherRoutes); // Teacher API: /api/teachers
  app.use("/api/v1/teaching-assignment", teachingAssignment); // Teaching Assignment API: /api/teaching-assignments
  app.use("/api/v1/classes", classRoutes); // Class API Version 1: /api/v1/classes
  app.use("/api/v1/school-admins", schoolAdmin); // School Admin API: /api/v1/schooladmins
  app.use("/api/v1/details-records", detailsRecord); // Details Record API: /api/v1/detailsrecords
  app.use("/api/v1/attendances", attendance); // Attendance API: /api/v1/attendances
  app.use("/api/v1/attendance", attendance); // Attendance API (singular): /api/v1/attendance (for QR code)
  app.use("/api/v1/news", newsRoute); // News API: /api/v1/news
  app.use("/api/v1/students", studentRoute); // Student API: /api/v1/students
  app.use("/api/v1/vip-packages", vipPackageRoute); // VIP Package API: /api/v1/vip-packages
  app.use("/api/v1/roles", roleRoute); // Roles API: /api/v1/roles
  app.use("/api/v1/discount-policies", discountPolicy); //Discount Policy: /api/v1/discount-policies
  app.use("/api/v1/extra-fees", extraFee); //Extra fee: /api/v1/extra-fees
  app.use("/api/v1/school-admin-dashboard", schoolAdminDashboardRoute); //Extra School Admin Dashboard: /api/v1/school-admin-dashboard
  app.use("/api/v1/membership-request", membershipRequestRoute); //Membership Request: /api/v1/membership-request
  app.use("/api/v1/grades", gradeRoute); //Grade: /api/v1/grades
  app.use("/api/v1/personnel", personnelRoute); //personnel: /api/v1/personnel
  app.use("/api/v1/upload", uploadRoute); //upload: /api/v1/upload
}
export default setupRoutes;
