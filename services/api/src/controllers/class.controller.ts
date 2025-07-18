import { Request, Response } from "express";
import chalk from "chalk";
import ClassService from "../services/class.service";

class ClassController {
  private classService: ClassService;

  constructor(classService: ClassService) {
    this.classService = classService;
  }

  async getAllClasses(req: Request, res: Response): Promise<void> {
    const userId = req.user?.id;

    try {
      const result = await this.classService.getAllClasses(userId);
      console.log(chalk.green("[CLASS] ✅ Get all classes"));

      res.status(200).json({ success: true, data: result });
      return;
    } catch (error) {
      console.log(chalk.red("[CLASS] ❌ Get all classes failed"), error);
      res.status(500).json({ success: false, message: "Lỗi hệ thống" });
      return;
    }
  }

  async getByIdClass(req: Request, res: Response): Promise<void> {
    const userId = req.user?.id;
    const { id } = req.params;

    try {
      const result = await this.classService.getClassById(userId, id);
      if (!result) {
        console.log(chalk.yellow("[CLASS] ⚠️ Not found class by ID"), id);
        res.status(404).json({ success: false, message: "Không tìm thấy lớp" });
        return;
      }

      console.log(chalk.green("[CLASS] ✅ Get class by ID"), id);
      res.status(200).json({ success: true, data: result });
      return;
    } catch (error) {
      console.log(chalk.red("[CLASS] ❌ Get class by ID failed"), error);
      res.status(500).json({ success: false, message: "Lỗi hệ thống" });
      return;
    }
  }

  async createClass(req: Request, res: Response): Promise<void> {
    const userId = req.user?.id;
    const body = req.body;

    try {
      const result = await this.classService.createClass(userId, body);
      console.log(
        chalk.green("[CLASS] ✅ Create class"),
        result._id.toString()
      );

      res.status(201).json({ success: true, data: result });
      return;
    } catch (error) {
      console.log(chalk.red("[CLASS] ❌ Create class failed"), error);
      res.status(400).json({ success: false, message: "Tạo lớp thất bại" });
      return;
    }
  }

  async updateClass(req: Request, res: Response): Promise<void> {
    const userId = req.user?.id;
    const { id } = req.params;
    const body = req.body;

    try {
      const result = await this.classService.updateClass(userId, id, body);
      if (!result) {
        console.log(chalk.yellow("[CLASS] ⚠️ Class not found to update"), id);
        res.status(404).json({ success: false, message: "Không tìm thấy lớp" });
        return;
      }

      console.log(chalk.green("[CLASS] ✅ Update class"), id);
      res.status(200).json({ success: true, data: result });
      return;
    } catch (error) {
      console.log(chalk.red("[CLASS] ❌ Update class failed"), error);
      res.status(400).json({ success: false, message: "Cập nhật thất bại" });
      return;
    }
  }

  async removeClass(req: Request, res: Response): Promise<void> {
    const userId = req.user?.id;
    const { id } = req.params;

    try {
      const result = await this.classService.deleteClass(userId, id);
      if (!result) {
        console.log(chalk.yellow("[CLASS] ⚠️ Class not found to delete"), id);
        res.status(404).json({ success: false, message: "Không tìm thấy lớp" });
        return;
      }

      console.log(chalk.green("[CLASS] ✅ Delete class"), id);
      res.status(200).json({ success: true, message: "Đã xóa lớp" });
      return;
    } catch (error) {
      console.log(chalk.red("[CLASS] ❌ Delete class failed"), error);
      res.status(500).json({ success: false, message: "Xóa lớp thất bại" });
      return;
    }
  }
}

export default ClassController;
