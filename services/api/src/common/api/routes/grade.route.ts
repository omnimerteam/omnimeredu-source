import { Request, Response, NextFunction, Router } from "express";
import { Grade } from "../../../domain/models";

// Import repository, service, controller
import {
  GradeRepository,
  ActivityLogRepository,
} from "../../../domain/repositories";
import { GradeService } from "../../../domain/services";
import { GradeController } from "../../../domain/controllers";

// Logger & Activity Log
import { DefaultLogger } from "../../utils/DefaultLogger";

// Middleware
import { verifyJWTToken } from "../middlewares/verifyJWTToken.middleware";
import { verifyRole } from "../middlewares/verifyRole";
import { validateData } from "../middlewares/validateData";

// Validator
import { authHeaderSchema } from "../../validators/common/header/header.validator";
import { objectIdParamSchema } from "../../validators/common/params/params.validator";
import {
  createGradeBodySchema,
  updateGradeBodySchema,
} from "../../validators/app/grade/grade.validator";
import { createPaginationSchemaWithSortAndFilter } from "../../validators/common/query/query.validator";

const logger = new DefaultLogger(new ActivityLogRepository());
const gradeRepository = new GradeRepository(Grade);
const gradeService = new GradeService(gradeRepository, logger);
const gradeController = new GradeController(gradeService);

const router = Router();

const getAllGradePaginationSchema = createPaginationSchemaWithSortAndFilter(
  ["name", "level", "order"],
  ["schoolId", "level", "active"]
);

// 🔹 Lấy danh sách tất cả khối
router.get(
  "/",
  validateData({
    headers: authHeaderSchema,
    query: getAllGradePaginationSchema,
  }),
  verifyJWTToken,
  async (req: Request, res: Response, next: NextFunction) =>
    gradeController.getAllGrades(req, res, next)
);

// 🔹 Lấy thông tin khối theo ID
router.get(
  "/:id",
  validateData({ params: objectIdParamSchema, headers: authHeaderSchema }),
  verifyJWTToken,
  async (req: Request, res: Response, next: NextFunction) =>
    gradeController.getGradeById(req, res, next)
);

// 🔹 Tạo khối mới (SuperAdmin)
router.post(
  "/",
  validateData({ headers: authHeaderSchema, body: createGradeBodySchema }),
  verifyJWTToken,
  verifyRole(["SuperAdmin", "SchoolAdmin"]),
  async (req: Request, res: Response, next: NextFunction) =>
    gradeController.createGrade(req, res, next)
);

// 🔹 Cập nhật khối (SuperAdmin)
router.put(
  "/:id",
  validateData({
    headers: authHeaderSchema,
    body: updateGradeBodySchema,
    params: objectIdParamSchema,
  }),
  verifyJWTToken,
  verifyRole(["SuperAdmin", "SchoolAdmin"]),
  async (req: Request, res: Response, next: NextFunction) =>
    gradeController.updateGrade(req, res, next)
);

// 🔹 Xóa khối (SuperAdmin)
router.delete(
  "/:id",
  validateData({ headers: authHeaderSchema, params: objectIdParamSchema }),
  verifyJWTToken,
  verifyRole(["SuperAdmin", "SchoolAdmin"]),
  async (req: Request, res: Response, next: NextFunction) =>
    gradeController.deleteGrade(req, res, next)
);

// 🔹 Lấy danh sách khối cho selectbox
router.get(
  "/select/box",
  validateData({ headers: authHeaderSchema }),
  verifyJWTToken,
  async (req: Request, res: Response, next: NextFunction) =>
    gradeController.getGradesForSelect(req, res, next)
);

export default router;
