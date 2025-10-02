import { Request, Response, NextFunction } from "express";
import chalk from "chalk";
import { RoleService } from "../../services";
import {
  sendSuccess,
  sendUnauthorized,
  sendEmpty,
} from "../../../common/utils/ResponseHelper";

class RoleController {
  private readonly roleService: RoleService;
  constructor(roleService: RoleService) {
    this.roleService = roleService;
  }

  async getAllRoles(
    req: Request,
    res: Response,
    next: NextFunction
  ): Promise<void> {
    try {
      const roles = await this.roleService.getAllRoles();
      if (!roles) {
        sendEmpty(res);
        return;
      }
      sendSuccess(res, roles, "Lấy danh sách vai trò thành công");
    } catch (error) {
      console.log(chalk.red("[Roles] Error getting all roles:", error));
      return next(error);
    }
  }

  async getRolesPersonnel(
    req: Request,
    res: Response,
    next: NextFunction
  ): Promise<void> {
    try {
      const roles = await this.roleService.getRolesPersonnel();
      if (!roles) {
        sendEmpty(res);
        return;
      }
      sendSuccess(res, roles, "Lấy danh sách vai trò thành công");
    } catch (error) {
      console.log(
        chalk.red("[Roles] Error getting all roles personnel:", error)
      );
      return next(error);
    }
  }
}

export default RoleController;
