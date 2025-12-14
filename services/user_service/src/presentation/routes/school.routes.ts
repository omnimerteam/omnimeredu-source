import { Router } from "express";
import { SchoolController } from "../controllers/SchoolController";

const router = Router();
const schoolController = new SchoolController();

// Get schools with filters
router.get("/", (req, res) => schoolController.getSchools(req, res));

// Get school by ID
router.get("/:id", (req, res) => schoolController.getSchoolById(req, res));

// Get classes by school ID
router.get("/:schoolId/classes", (req, res) => schoolController.getClassesBySchool(req, res));

// Create school
router.post("/", (req, res) => schoolController.registerSchool(req, res));

// Update school
router.put("/:id", (req, res) => schoolController.updateSchool(req, res));

// Delete school
router.delete("/:id", (req, res) => schoolController.deleteSchool(req, res));

export default router;
