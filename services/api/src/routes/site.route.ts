import indexRoutes from "./index";
import schoolRouter from "./school.route";
import authRoutes from "./auth.route";
import classRoutes from "./class.route";
import teacherRoutes from "./teacher.route";

import { Express } from "express";

function setupRoutes(app: Express) {
  app.use("/", indexRoutes); // Root:/
  app.use("/api", authRoutes); // Auth API: /api/auth
  app.use("/api", schoolRouter); // School API: /api/schools
  app.use("/api", teacherRoutes); // Teacher API: /api/teachers
  app.use("/api/v1/classes", classRoutes); // Class API Version 1: /api/v1/classes
}
export default setupRoutes;
