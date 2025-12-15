import { Router } from "express";
import userRoutes from "./user.routes";
import schoolRoutes from "./school.routes";
import gradeRoutes from "./grade.routes";
import classRoutes from "./class.routes";
import authRoutes from "./auth.routes";

const router = Router();

router.use("/auth", authRoutes);
router.use("/users", userRoutes);
router.use("/schools", schoolRoutes);
router.use("/grades", gradeRoutes);
router.use("/classes", classRoutes);

export default router;
