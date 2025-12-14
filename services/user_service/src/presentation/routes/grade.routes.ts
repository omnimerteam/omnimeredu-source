import { Router } from "express";
import { GradeController } from "../controllers/GradeController";

const router = Router();
const gradeController = new GradeController();

// Create grade
router.post("/", (req, res) => gradeController.createGrade(req, res));

// Get grade by ID
router.get("/:id", (req, res) => gradeController.getGradeById(req, res));

// Get grades by school ID
router.get("/school/:schoolId", (req, res) =>
  gradeController.getGradesBySchoolId(req, res)
);

// Update grade
router.put("/:id", (req, res) => gradeController.updateGrade(req, res));

// Delete grade
router.delete("/:id", (req, res) => gradeController.deleteGrade(req, res));

export default router;
