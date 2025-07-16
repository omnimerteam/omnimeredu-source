import { Types } from "mongoose";
import { ClassRepository } from "../repositories/class.repository";
import { logActivity } from "../utils/logger";

export class ClassService {
  private readonly classRepo = new ClassRepository();

  async createClass(input: {
    name: string;
    code: string;
    schoolId: string;
    teacherId?: string;
    students?: string[];
    baseFee: number;
    performedBy: string; // userId thực hiện
    roleSnapshot: string; // vai trò người tạo
  }) {
    const {
      name,
      code,
      schoolId,
      teacherId,
      students,
      baseFee,
      performedBy,
      roleSnapshot,
    } = input;

    const result = await this.classRepo.createClass({
      name,
      code,
      schoolId: new Types.ObjectId(schoolId),
      teacherId: teacherId ? new Types.ObjectId(teacherId) : undefined,
      students: students?.map((id) => new Types.ObjectId(id)),
      baseFee,
    });

    if ("_id" in result) {
      // Ghi log thành công
      await logActivity({
        userId: performedBy,
        action: "createClass",
        targetId: result._id,
        roleSnapshot,
        metadata: {
          className: name,
          schoolId,
        },
      });
      return result;
    } else {
      // Ghi log thất bại
      await logActivity({
        userId: performedBy,
        action: "createClassFailed",
        roleSnapshot,
        metadata: {
          reason: result.error,
          className: name,
          code,
        },
      });
      throw new Error(result.error);
    }
  }
}
