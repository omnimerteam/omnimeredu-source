import { NextFunction, Request, Response, Router } from "express";

//import các model, repository, service và controller cần thiết
import { School } from "../../../domain/models";
import {
  SchoolRepository,
  ActivityLogRepository,
} from "../../../domain/repositories";
import { SchoolService } from "../../../domain/services";
import { SchoolController } from "../../../domain/controllers";

// Logger & Activity Log
import { DefaultLogger } from "../../utils/DefaultLogger";

// Middleware
import { verifyFirebaseToken } from "../middlewares/verifyFirebaseToken";
import { verifyRole } from "../middlewares/verifyRole";
import { validateData } from "../middlewares/validateData";
import { searchSchoolsQuerySchema } from "../../validators/query/query.validator";

const router = Router();

//Khởi tạo và truyền giá trị vào các constructor
//Lưu ý cần phải theo thứ tự từ Model -> Repository -> Service -> Controller
const logger = new DefaultLogger(new ActivityLogRepository());
const schoolRepository = new SchoolRepository(School);
const schoolService = new SchoolService(schoolRepository, logger);
const schoolController = new SchoolController(schoolService);

//Cần chắc chắn để router search đầu tiên để không bị các route khác chặn
router.get(
  "/search/query",
  validateData({ query: searchSchoolsQuerySchema }),
  (req: Request, res: Response, next: NextFunction) =>
    schoolController.searchSchoolByNameOrCode(req, res, next)
);

router.get(
  "/:id",
  verifyFirebaseToken,
  verifyRole(["SuperAdmin", "SchoolAdmin"]),
  (req: Request, res: Response, next: NextFunction) =>
    schoolController.getSchoolById(req, res, next)
);

router.get(
  "/",
  verifyFirebaseToken,
  verifyRole(["SuperAdmin", "SchoolAdmin"]),
  (req: Request, res: Response, next: NextFunction) =>
    schoolController.getAllSchools(req, res, next)
);

router.post(
  "/",
  verifyFirebaseToken,
  verifyRole(["SuperAdmin", "SchoolAdmin"]),
  (req: Request, res: Response, next: NextFunction) =>
    schoolController.createSchool(req, res, next)
);

router.put(
  "/:id",
  verifyFirebaseToken,
  verifyRole(["SuperAdmin", "SchoolAdmin"]),
  (req: Request, res: Response, next: NextFunction) =>
    schoolController.updateSchool(req, res, next)
);

router.delete(
  "/:id",
  verifyFirebaseToken,
  verifyRole(["SuperAdmin", "SchoolAdmin"]),
  (req: Request, res: Response, next: NextFunction) =>
    schoolController.deleteSchool(req, res, next)
);

export default router;
