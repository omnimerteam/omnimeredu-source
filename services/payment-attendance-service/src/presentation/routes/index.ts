import { Router } from "express";
import attendanceRoutes from "./attendance.routes";
import tuitionRoutes from "./tuition.routes";
import paymentRoutes from "./payment.routes";
import holidayRoutes from "./holiday.routes";

const router = Router();

router.use("/attendance", attendanceRoutes);
router.use("/tuition", tuitionRoutes);
router.use("/payments", paymentRoutes);
router.use("/holidays", holidayRoutes);

export default router;
