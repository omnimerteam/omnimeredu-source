import { Router } from "express";
import { SchoolController } from "../controllers/SchoolController";

const router = Router();
const schoolController = new SchoolController();

// Create school
router.post("/", (req, res) => schoolController.registerSchool(req, res));

// Get school by ID
router.get("/:id", (req, res) => schoolController.getSchoolById(req, res));

// Update school
router.put("/:id", (req, res) => schoolController.updateSchool(req, res));

// Delete school
router.delete("/:id", (req, res) => schoolController.deleteSchool(req, res));

export default router;
