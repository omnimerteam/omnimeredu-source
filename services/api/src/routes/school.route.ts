import { NextFunction, Request, Response, Router } from 'express';
import schoolModel from '../models/School';

//import các model, repository, service và controller cần thiết
import SchoolRepository from '../repositories/school.repository';
import SchoolService from '../services/school.services';
import SchoolController from '../controllers/school.controller';


// Logger & Activity Log    
import { ActivityLogRepository } from '../repositories/activityLog.repository';
import { DefaultLogger } from '../utils/DefaultLogger';

// Middleware
import { verifyFirebaseToken } from "../middlewares/verifyFirebaseToken";
import { verifyRole } from "../middlewares/verifyRole";

const router = Router();

//Khởi tạo và truyền giá trị vào các constructor
//Lưu ý cần phải theo thứ tự từ Model -> Repository -> Service -> Controller
const logger = new DefaultLogger(new ActivityLogRepository());
const schoolRepository = new SchoolRepository(schoolModel);
const schoolService = new SchoolService(schoolRepository, logger);
const schoolController = new SchoolController(schoolService);

//Cần chắc chắn để router search đầu tiên để không bị các route khác chặn
router.get('/schools/search',
    verifyFirebaseToken,
    verifyRole(["SuperAdmin", "SchoolAdmin"]),
    (req: Request, res: Response, next: NextFunction) => schoolController.getSchoolByNameOrCode(req, res, next));

router.get('/schools/:id',
    verifyFirebaseToken,
    verifyRole(["SuperAdmin", "SchoolAdmin"]),
    (req: Request, res: Response, next: NextFunction) => schoolController.getSchoolById(req, res, next));

router.get('/schools',
    verifyFirebaseToken,
    verifyRole(["SuperAdmin", "SchoolAdmin"]),
    (req: Request, res: Response, next: NextFunction) => schoolController.getAllSchools(req, res, next));

router.post('/schools',
    verifyFirebaseToken,
    verifyRole(["SuperAdmin", "SchoolAdmin"]),
    (req: Request, res: Response, next: NextFunction) => schoolController.createSchool(req, res, next));

router.put('/schools/:id',
    verifyFirebaseToken,
    verifyRole(["SuperAdmin", "SchoolAdmin"]),
    (req: Request, res: Response, next: NextFunction) => schoolController.updateSchool(req, res, next));

router.delete('/schools/:id',
    verifyFirebaseToken,
    verifyRole(["SuperAdmin", "SchoolAdmin"]),
    (req: Request, res: Response, next: NextFunction) => schoolController.deleteSchool(req, res, next));

export default router;
