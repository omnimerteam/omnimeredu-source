import { Request, Response, Router } from 'express';
import schoolModel from '../models/School';
//import các model, repository, service và controller cần thiết
import SchoolRepository from '../repositories/school.repository';
import SchoolService from '../services/school.services';
import SchoolController from '../controllers/school.controller';

const router = Router();

//Khởi tạo và truyền giá trị vào các constructor
//Lưu ý cần phải theo thứ tự từ Model -> Repository -> Service -> Controller
const schoolRepository = new SchoolRepository(schoolModel);
const schoolService = new SchoolService(schoolRepository);
const schoolController = new SchoolController(schoolService);

//Cần chắc chắn để router search đầu tiên để không bị các route khác chặn
router.get('/schools/search', (req: Request, res: Response) => schoolController.getSchoolByNameOrCode(req, res));
router.get('/schools/:id', (req: Request, res: Response) => schoolController.getSchoolById(req, res));
router.get('/schools', (req: Request, res: Response) => schoolController.getAllSchools(req, res));
router.post('/schools', (req: Request, res: Response) => schoolController.createSchool(req, res));
router.put('/schools/:id', (req: Request, res: Response) => schoolController.updateSchool(req, res));
router.delete('/schools/:id', (req: Request, res: Response) => schoolController.deleteSchool(req, res));

export default router;
