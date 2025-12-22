import { Router } from "express";
import attendanceRoutes from "./attendance.routes";
import attendanceReadRoutes from "./attendance-read.routes";
import tuitionRoutes from "./tuition.routes";
import paymentRoutes from "./payment.routes";
import paymentReadRoutes from "./payment-read.routes";
import holidayRoutes from "./holiday.routes";

const router = Router();

// Write APIs (PostgreSQL)
router.use("/attendance", attendanceRoutes);
router.use("/tuition", tuitionRoutes);
router.use("/payments", paymentRoutes);
router.use("/holidays", holidayRoutes);

// Read APIs (MongoDB) - Optimized for reports and analytics
router.use("/attendance", attendanceReadRoutes);
router.use("/payments", paymentReadRoutes);

export default router;
