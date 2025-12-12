import { Router } from "express";
import { TuitionRepositoryImpl } from "../../data/repositories/TuitionRepositoryImpl";
import { CreateTuitionUseCase } from "../../domain/usecases/tuition/CreateTuitionUseCase";
import { GetTuitionByIdUseCase } from "../../domain/usecases/tuition/GetTuitionByIdUseCase";
import { GetTuitionsByPeriodUseCase } from "../../domain/usecases/tuition/GetTuitionsByPeriodUseCase";
import { ConfirmTuitionUseCase } from "../../domain/usecases/tuition/ConfirmTuitionUseCase";
import { TuitionController } from "../controllers/TuitionController";

const router = Router();

const tuitionRepo = new TuitionRepositoryImpl();

const createTuitionUseCase = new CreateTuitionUseCase(tuitionRepo);
const getTuitionByIdUseCase = new GetTuitionByIdUseCase(tuitionRepo);
const getTuitionsByPeriodUseCase = new GetTuitionsByPeriodUseCase(tuitionRepo);
const confirmTuitionUseCase = new ConfirmTuitionUseCase(tuitionRepo);

const tuitionController = new TuitionController(
    createTuitionUseCase,
    getTuitionByIdUseCase,
    getTuitionsByPeriodUseCase,
    confirmTuitionUseCase
);

router.post("/", (req, res) => tuitionController.create(req, res));
router.get("/:id", (req, res) => tuitionController.getById(req, res));
router.get("/", (req, res) => tuitionController.getByPeriod(req, res));
router.post("/:id/confirm", (req, res) => tuitionController.confirm(req, res));

export default router;
