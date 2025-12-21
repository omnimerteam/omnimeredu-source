import { Router } from "express";

// Models → Repo → Service → Controller
import { Class, ClassDetailView, Grade, Student } from "../../../domain/models";
import {
  ClassRepository,
  StudentRepository,
  ActivityLogRepository,
  ClassDetailViewRepository,
} from "../../../domain/repositories";
import { ClassService } from "../../../domain/services";
import { ClassController } from "../../../domain/controllers";

// Logger & Activity Log
import { DefaultLogger } from "../../utils/DefaultLogger";

// Middleware
import { verifyJWTToken } from "../middlewares/verifyJWTToken.middleware";
import { verifyRole } from "../middlewares/verifyRole";
import { validateData } from "../middlewares/validateData";

// Validators
import {
  createClassBodySchema,
  modifyStudentsBodySchema,
  transferClassBodySchema,
  updateClassBodySchema,
} from "../../validators/app/class/class.validator";
import { objectIdParamSchema } from "../../validators/common/params/params.validator";
import { authHeaderSchema } from "../../validators/common/header/header.validator";
import {
  createPaginationSchemaWithSortAndFilter,
  searchClassesQuerySchema,
} from "../../validators/common/query/query.validator";

// Init Dependencies
const classRepository = new ClassRepository(Class);
const classDetailViewRepository = new ClassDetailViewRepository(
  ClassDetailView
);
const studentRepository = new StudentRepository(Student, Grade);
const logger = new DefaultLogger(new ActivityLogRepository());
const classService = new ClassService(
  classRepository,
  logger,
  studentRepository,
  classDetailViewRepository
);
const classController = new ClassController(classService);

// Custom Validate
const getAllClassPaginationSchema = createPaginationSchemaWithSortAndFilter(
  ["name", "code", "schoolId", "baseFee"],
  ["gradeId", "maxStudents"]
);

// Router
const router = Router();

/**
 * ROUTE DEFINITIONS
 */

//  Lấy tất cả lớp (có filter query)
router.get(
  "/",
  validateData({
    headers: authHeaderSchema,
    query: getAllClassPaginationSchema,
  }),
  verifyJWTToken,
  verifyRole(["SuperAdmin", "SchoolAdmin", "Teacher"]),
  (req, res, next) => classController.getAllClasses(req, res, next)
);

//  Lấy tất cả lớp trong view model ClassDetail (có filter query)
router.get(
  "/view-model/class-detail",
  validateData({
    headers: authHeaderSchema,
    query: getAllClassPaginationSchema,
  }),
  verifyJWTToken,
  verifyRole(["SuperAdmin", "SchoolAdmin", "Teacher"]),
  (req, res, next) => classController.getAllClassDetailView(req, res, next)
);

router.get(
  "/view-model/class-detail/:id",
  validateData({
    headers: authHeaderSchema,
    params: objectIdParamSchema,
  }),
  verifyJWTToken,
  verifyRole(["SuperAdmin", "SchoolAdmin", "Teacher"]),
  (req, res, next) => classController.getClassDetailViewById(req, res, next)
);

//  Lấy lớp theo ID
router.get(
  "/:id",
  validateData({ headers: authHeaderSchema, params: objectIdParamSchema }),
  verifyJWTToken,
  verifyRole(["SuperAdmin", "SchoolAdmin", "Teacher"]),
  (req, res, next) => classController.getClassById(req, res, next)
);

//  Tạo lớp mới
router.post(
  "/",
  validateData({ headers: authHeaderSchema, body: createClassBodySchema }),
  verifyJWTToken,
  verifyRole(["SuperAdmin", "SchoolAdmin"]),
  (req, res, next) => classController.createClass(req, res, next)
);

//  Cập nhật lớp
router.put(
  "/:id",
  validateData({
    headers: authHeaderSchema,
    params: objectIdParamSchema,
    body: updateClassBodySchema,
  }),
  verifyJWTToken,
  verifyRole(["SuperAdmin", "SchoolAdmin"]),
  (req, res, next) => classController.updateClass(req, res, next)
);

//  Xóa lớp
router.delete(
  "/:id",
  validateData({ headers: authHeaderSchema, params: objectIdParamSchema }),
  verifyJWTToken,
  verifyRole(["SuperAdmin", "SchoolAdmin"]),
  (req, res, next) => classController.deleteClass(req, res, next)
);

//  Thêm học sinh vào lớp
router.post(
  "/:id/students/add",
  validateData({
    headers: authHeaderSchema,
    params: objectIdParamSchema,
    body: modifyStudentsBodySchema,
  }),
  verifyJWTToken,
  verifyRole(["SuperAdmin", "SchoolAdmin", "Teacher"]),

  (req, res, next) => classController.addStudentToClass(req, res, next)
);

//  Xóa học sinh khỏi lớp
router.post(
  "/:id/students/remove",
  validateData({
    headers: authHeaderSchema,
    params: objectIdParamSchema,
    body: modifyStudentsBodySchema,
  }),
  verifyJWTToken,
  verifyRole(["SuperAdmin", "SchoolAdmin", "Teacher"]),
  (req, res, next) => classController.removeStudentFromClass(req, res, next)
);

//  Trao đổi học sinh giữa các lớp
router.post(
  "/:id/students/transfer",
  validateData({
    headers: authHeaderSchema,
    params: objectIdParamSchema,
    body: transferClassBodySchema,
  }),
  verifyJWTToken,
  verifyRole(["SuperAdmin", "SchoolAdmin", "Teacher"]),
  (req, res, next) => classController.transferClass(req, res, next)
);

//  Tìm kiếm lớp học có trong trường theo name hoặc code của trường
router.get(
  "/schools/search",
  validateData({ query: searchClassesQuerySchema }),
  (req, res, next) => classController.searchClassesInSchool(req, res, next)
);

export default router;
