import { Router } from "express";
import { ClassController } from "../controllers/class.controller";
import { verifyFirebaseToken } from "../middlewares/verifyFirebaseToken"; // giả định
import { verifyRole } from "../middlewares/verifyRole";

const router = Router();
const controller = new ClassController();

router.post(
  "/",
  verifyFirebaseToken,
  verifyRole(["SuperAdmin", "SchoolAdmin"]),
  controller.createClass
);

export default router;
