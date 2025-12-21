import { Request, Response, NextFunction, Router } from "express";
import { Teacher } from "../../../domain/models";

// Import các model, repository, service và controller cần thiết
import {
  TeacherRepository,
  ActivityLogRepository,
} from "../../../domain/repositories";
import { TeacherService } from "../../../domain/services";
import { TeacherController } from "../../../domain/controllers";

// Logger & Activity Log
import { DefaultLogger } from "../../utils/DefaultLogger";

// Middleware
import { verifyJWTToken } from "../middlewares/verifyJWTToken.middleware";
import { verifyRole } from "../middlewares/verifyRole";
import { validateData } from "../middlewares/validateData";
import { authHeaderSchema } from "../../validators/common/header/header.validator";
import { createPaginationSchemaWithSortAndFilter } from "../../validators/common/query/query.validator";

// Khởi tạo và truyền giá trị vào các constructor
const logger = new DefaultLogger(new ActivityLogRepository());
const teacherRepository = new TeacherRepository(Teacher);
const teacherService = new TeacherService(teacherRepository, logger);
const teacherController = new TeacherController(teacherService);

const router = Router();

const teacherQuerySchema = createPaginationSchemaWithSortAndFilter(
  ["fullName", "createdAt", "birthday"],
  ["gender", "literacy", "subjects"]
);

router.get(
  "/",
  validateData({
    headers: authHeaderSchema,
    query: teacherQuerySchema,
  }),
  verifyJWTToken,
  verifyRole(["SuperAdmin", "SchoolAdmin"]),
  async (req: Request, res: Response, next: NextFunction) =>
    teacherController.getAllTeachers(req, res, next)
);

router.get(
  "/:id",
  verifyJWTToken,
  verifyRole(["SuperAdmin"]),
  async (req: Request, res: Response, next: NextFunction) =>
    teacherController.getTeacherById(req, res, next)
);

router.post(
  "/",
  verifyJWTToken,
  verifyRole(["SuperAdmin"]),
  async (req: Request, res: Response, next: NextFunction) =>
    teacherController.createTeacher(req, res, next)
);

router.put(
  "/:id",
  verifyJWTToken,
  verifyRole(["SuperAdmin", "Teacher"]),
  async (req: Request, res: Response, next: NextFunction) =>
    teacherController.updateTeacher(req, res, next)
);

router.delete(
  "/:id",
  verifyJWTToken,
  verifyRole(["SuperAdmin"]),
  async (req: Request, res: Response, next: NextFunction) =>
    teacherController.deleteTeacher(req, res, next)
);

export default router;

/** example request body for creating a teacher
 * {
        "fullName": "Nguyễn Văn DADA",
        "roleId": "6885e31812e74de500041b53",  
        "gender": "Male",
        "birthday": "2000-10-13",
        "phone": "0909032",
        "address": "Long An",
        "isVerified": true,
        "literacy": "abcbca",
        "subjects": ["Math"],   
        "schoolId": "6885e31812e74de500041b51"
      }
 */
