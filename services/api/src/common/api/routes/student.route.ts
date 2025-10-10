import { Request, Response, NextFunction, Router } from "express";
import { Student } from "../../../domain/models";

// Import các model, repository, service và controller cần thiết
import {
  StudentRepository,
  ActivityLogRepository,
} from "../../../domain/repositories";
import { StudentService } from "../../../domain/services";
import { StudentController } from "../../../domain/controllers";

// Logger & Activity Log
import { DefaultLogger } from "../../utils/DefaultLogger";

// Middleware
import { verifyFirebaseToken } from "../middlewares/verifyFirebaseToken";
import { verifyRole } from "../middlewares/verifyRole";
import { validateData } from "../middlewares/validateData";

// Validator
import { authHeaderSchema } from "../../validators/header/header.validator";
import { objectIdParamSchema } from "../../validators/params/params.validator";
import {
  createStudentBodySchema,
  updateStudentBodySchema,
} from "../../validators/student/student.validator";

// Khởi tạo và truyền giá trị vào các constructor
const logger = new DefaultLogger(new ActivityLogRepository());
const studentRepository = new StudentRepository(Student);
const studentService = new StudentService(studentRepository, logger);
const studentController = new StudentController(studentService);

const router = Router();

router.get(
  "/",
  validateData({ headers: authHeaderSchema }),
  verifyFirebaseToken,
  verifyRole(["Teacher", "SchoolAdmin"]),
  async (req: Request, res: Response, next: NextFunction) =>
    studentController.getAllStudents(req, res, next)
);

router.get(
  "/:id",
  validateData({ headers: authHeaderSchema, params: objectIdParamSchema }),
  verifyFirebaseToken,
  verifyRole(["Teacher", "SchoolAdmin"]),
  async (req: Request, res: Response, next: NextFunction) =>
    studentController.getStudentById(req, res, next)
);

router.post(
  "/",
  validateData({ headers: authHeaderSchema, body: createStudentBodySchema }),
  verifyFirebaseToken,
  verifyRole(["Teacher", "SchoolAdmin", "Student"]),
  async (req: Request, res: Response, next: NextFunction) =>
    studentController.createStudent(req, res, next)
);

router.put(
  "/:id",
  validateData({
    headers: authHeaderSchema,
    body: updateStudentBodySchema,
    params: objectIdParamSchema,
  }),
  verifyFirebaseToken,
  verifyRole(["Teacher", "SchoolAdmin", "Student"]),
  async (req: Request, res: Response, next: NextFunction) =>
    studentController.updateStudent(req, res, next)
);

router.delete(
  "/:id",
  validateData({ headers: authHeaderSchema, params: objectIdParamSchema }),
  verifyFirebaseToken,
  verifyRole(["Student"]),
  async (req: Request, res: Response, next: NextFunction) =>
    studentController.deleteStudent(req, res, next)
);

export default router;
