import { Request, Response } from "express";
import { ClassService } from "../services/class.service";

export class ClassController {
  private readonly classService = new ClassService();

  async createClass(req: Request, res: Response): Promise<void> {
    try {
      const result = await this.classService.createClass({
        ...req.body,
        performedBy: req.user.userId, // cần middleware gán user
        roleSnapshot: req.role,
      });
      res.status(201).json(result);
      return;
    } catch (error: any) {
      res.status(400).json({ message: error.message });
      return;
    }
  }
}
