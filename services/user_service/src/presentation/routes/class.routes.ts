import { Router } from "express";
import { ClassController } from "../controllers/ClassController";

const router = Router();
const classController = new ClassController();

// Create class
router.post("/", (req, res) => classController.createClass(req, res));

// Get class by ID
router.get("/:id", (req, res) => classController.getClassById(req, res));

// Get students by class ID (Read from MongoDB)
router.get("/:id/students", (req, res) =>
  classController.getStudentsByClassId(req, res)
);

// Get classes by school ID
router.get("/school/:schoolId", (req, res) =>
  classController.getClassesBySchoolId(req, res)
);

// Update class
router.put("/:id", (req, res) => classController.updateClass(req, res));

// Delete class
router.delete("/:id", (req, res) => classController.deleteClass(req, res));

export default router;
