import { Router } from "express";
import { HolidayRepositoryImpl } from "../../data/repositories/HolidayRepositoryImpl";
import { CreateHolidayUseCase } from "../../domain/usecases/holiday/CreateHolidayUseCase";
import { GetHolidaysByDateRangeUseCase } from "../../domain/usecases/holiday/GetHolidaysByDateRangeUseCase";
import { CheckIsHolidayUseCase } from "../../domain/usecases/holiday/CheckIsHolidayUseCase";
import { HolidayController } from "../controllers/HolidayController";

const router = Router();

const holidayRepo = new HolidayRepositoryImpl();

const createHolidayUseCase = new CreateHolidayUseCase(holidayRepo);
const getHolidaysByDateRangeUseCase = new GetHolidaysByDateRangeUseCase(holidayRepo);
const checkIsHolidayUseCase = new CheckIsHolidayUseCase(holidayRepo);

const holidayController = new HolidayController(
    createHolidayUseCase,
    getHolidaysByDateRangeUseCase,
    checkIsHolidayUseCase
);

router.post("/", (req, res) => holidayController.create(req, res));
router.get("/", (req, res) => holidayController.getByDateRange(req, res));
router.get("/check", (req, res) => holidayController.checkIsHoliday(req, res));

export default router;
