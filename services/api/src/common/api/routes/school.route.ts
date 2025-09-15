import { NextFunction, Request, Response, Router } from "express";

//import các model, repository, service và controller cần thiết
import { School, SchoolAdmin } from "../../../domain/models";
import {
  SchoolRepository,
  ActivityLogRepository,
  SchoolAdminRepository,
} from "../../../domain/repositories";
import { SchoolService } from "../../../domain/services";
import { SchoolController } from "../../../domain/controllers";

// Logger & Activity Log
import { DefaultLogger } from "../../utils/DefaultLogger";

// Middleware
import { verifyFirebaseToken } from "../middlewares/verifyFirebaseToken";
import { verifyRole } from "../middlewares/verifyRole";
import { validateData } from "../middlewares/validateData";
import { searchSchoolsQuerySchema } from "../../validators/common/query/query.validator";
import {
  createSchoolBodySchema,
  updateSchoolBodySchema,
} from "../../validators/app/school/school.validator";
import { authHeaderSchema } from "../../validators/common/header/header.validator";

const router = Router();

//Khởi tạo và truyền giá trị vào các constructor
//Lưu ý cần phải theo thứ tự từ Model -> Repository -> Service -> Controller
const logger = new DefaultLogger(new ActivityLogRepository());
const schoolRepository = new SchoolRepository(School);
const schoolAdminRepository = new SchoolAdminRepository(SchoolAdmin);
const schoolService = new SchoolService(
  schoolRepository,
  logger,
  schoolAdminRepository
);
const schoolController = new SchoolController(schoolService);

//Cần chắc chắn để router search đầu tiên để không bị các route khác chặn
router.get(
  "/search/query",
  validateData({ query: searchSchoolsQuerySchema }),
  (req: Request, res: Response, next: NextFunction) =>
    schoolController.searchSchoolByEducationLevel(req, res, next)
);

router.get(
  "/school-admin",
  validateData({ headers: authHeaderSchema }),
  verifyFirebaseToken,
  verifyRole(["SchoolAdmin"]),
  (req: Request, res: Response, next: NextFunction) =>
    schoolController.getSchoolDetailForSchoolAdmin(req, res, next)
);

// Todo: Hàm này ko nên tồn tại hoặc nên hiệu chỉnh cho nó tránh hiển thị các thông tin nhạy cảm cảm của trường hoặc thiếu cần thiết
router.get(
  "/",
  verifyFirebaseToken,
  verifyRole(["SuperAdmin", "SchoolAdmin"]),
  (req: Request, res: Response, next: NextFunction) =>
    schoolController.getAllSchools(req, res, next)
);

router.post(
  "/",
  validateData({ headers: authHeaderSchema, body: createSchoolBodySchema }),
  verifyFirebaseToken,
  verifyRole(["SuperAdmin", "SchoolAdmin"]),
  (req: Request, res: Response, next: NextFunction) =>
    schoolController.createSchool(req, res, next)
);

router.put(
  "/",
  validateData({ headers: authHeaderSchema, body: updateSchoolBodySchema }),
  verifyFirebaseToken,
  verifyRole(["SchoolAdmin"]),
  (req: Request, res: Response, next: NextFunction) =>
    schoolController.updateSchool(req, res, next)
);

router.delete(
  "/",
  validateData({ headers: authHeaderSchema }),
  verifyFirebaseToken,
  verifyRole(["SchoolAdmin"]),
  (req: Request, res: Response, next: NextFunction) =>
    schoolController.deleteSchool(req, res, next)
);

export default router;
