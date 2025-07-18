import indexRoutes from "./index";
import schoolRouter from "./school.route";
import authRoutes from "./auth.route";

import { Express } from "express";

function setupRoutes(app: Express) {
    app.use("/", indexRoutes); // Root:/
    app.use("/api", schoolRouter);// School API: /api/schools
    app.use("/api", authRoutes);// Auth API: /api/auth
}
export default setupRoutes;