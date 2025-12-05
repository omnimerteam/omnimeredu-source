import { Router } from "express";
import { SchoolController } from "../controllers/SchoolController";

const router = Router();
const schoolController = new SchoolController();

router.post("/", (req, res) => schoolController.registerSchool(req, res));

export default router;
