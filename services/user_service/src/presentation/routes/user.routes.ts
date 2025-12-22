import { Router, Request, Response } from "express";
import { UserController } from "../controllers/UserController";

const router = Router();
const userController = new UserController();

router.post("/", (req: Request, res: Response) =>
  userController.createUser(req, res)
);

export default router;
