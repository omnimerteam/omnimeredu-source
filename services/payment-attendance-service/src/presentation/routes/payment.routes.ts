import { Router } from "express";
import { PaymentRepositoryImpl } from "../../data/repositories/PaymentRepositoryImpl";
import { TuitionRepositoryImpl } from "../../data/repositories/TuitionRepositoryImpl";
import { CreatePaymentUseCase } from "../../domain/usecases/payment/CreatePaymentUseCase";
import { GetPaymentsByStudentIdUseCase } from "../../domain/usecases/payment/GetPaymentsByStudentIdUseCase";
import { ProcessPaymentCallbackUseCase } from "../../domain/usecases/payment/ProcessPaymentCallbackUseCase";
import { PaymentController } from "../controllers/PaymentController";

const router = Router();

const paymentRepo = new PaymentRepositoryImpl();
const tuitionRepo = new TuitionRepositoryImpl();

const createPaymentUseCase = new CreatePaymentUseCase(paymentRepo, tuitionRepo);
const getPaymentsByStudentIdUseCase = new GetPaymentsByStudentIdUseCase(paymentRepo);
const processPaymentCallbackUseCase = new ProcessPaymentCallbackUseCase(paymentRepo, tuitionRepo);

const paymentController = new PaymentController(
    createPaymentUseCase,
    getPaymentsByStudentIdUseCase,
    processPaymentCallbackUseCase
);

router.post("/", (req, res) => paymentController.create(req, res));
router.get("/student/:studentId", (req, res) => paymentController.getByStudent(req, res));
router.post("/callback", (req, res) => paymentController.callback(req, res));

export default router;
