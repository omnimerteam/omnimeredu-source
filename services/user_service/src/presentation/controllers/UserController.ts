import { Request, Response } from "express";
import { CreateUserUseCase } from "../../domain/usecases/user/CreateUserUseCase";
import { UserRepositoryImpl } from "../../data/repositories/UserRepositoryImpl";
import { CreateUserDto } from "../dtos/CreateUserDto";

import { RoleRepositoryImpl } from "../../data/repositories/RoleRepositoryImpl";
import { ResponseUtil } from "../../infrastructure/utils/ResponseUtil";

export class UserController {
  private createUserUseCase: CreateUserUseCase;

  constructor() {
    const userRepository = new UserRepositoryImpl();
    const roleRepository = new RoleRepositoryImpl();
    this.createUserUseCase = new CreateUserUseCase(
      userRepository,
      roleRepository
    );
  }

  async createUser(req: Request, res: Response): Promise<void> {
    try {
      const dto: CreateUserDto = req.body;
      const user = await this.createUserUseCase.execute(dto);
      ResponseUtil.sendSuccess(res, "User created successfully", user, 201);
    } catch (error: any) {
      ResponseUtil.sendError(res, error.message, error, 400);
    }
  }
}
