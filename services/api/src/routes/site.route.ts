import indexRoutes from "./index";
import schoolRouter from "./school.route";
import authRoutes from "./auth.route";
import classRoutes from "./class.route";
import teacherRoutes from "./teacher.route";
import teachingAssignment from "./teachingAssignment.route";
import schoolAdmin from "./schoolAdmin.route";

import { Express } from "express";

function setupRoutes(app: Express) {
  app.use("/", indexRoutes); // Root:/
  app.use("/api/v1/auth", authRoutes); // Auth API: /api/auth
  app.use("/api/v1/schools", schoolRouter); // School API: /api/schools
  app.use("/api/v1/teachers", teacherRoutes); // Teacher API: /api/teachers
  app.use("/api/v1/teachingassignment", teachingAssignment); // Teaching Assignment API: /api/teachingassignments
  app.use("/api/v1/classes", classRoutes); // Class API Version 1: /api/v1/classes
  app.use("/api/v1/schooladmins", schoolAdmin); // School Admin API: /api/v1/schooladmins
}
export default setupRoutes;
