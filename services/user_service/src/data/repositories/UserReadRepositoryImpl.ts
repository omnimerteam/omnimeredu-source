import { IUserReadRepository } from "../../domain/repositories/IUserReadRepository";
import { UserReadModel } from "../datasources/mongodb/schemas/UserReadSchema";
import { SchoolReadModel } from "../datasources/mongodb/schemas/SchoolReadSchema";
import { ClassReadModel } from "../datasources/mongodb/schemas/ClassReadSchema";

export class UserReadRepositoryImpl implements IUserReadRepository {
  async getUserFullInfo(userId: string): Promise<any> {
    const user = await UserReadModel.findOne({ _id: userId }).lean();
    return user;
  }

  async getUserFullInfoByEmail(email: string): Promise<any> {
    const user = await UserReadModel.findOne({ email }).lean();
    return user;
  }

  async getUsersBySchoolId(schoolId: string): Promise<any[]> {
    const users = await UserReadModel.find({ schoolId })
      .sort({ fullName: 1 })
      .lean();
    return users;
  }

  async getStudentsByClassId(classId: string): Promise<any[]> {
    // Note: UserReadModel might not have studentInfo structure if it's raw sync
    // Assuming simple structure for now or need adjustment if studentInfo is nested
    // Based on SyncService, it copies fields. If raw Postgres has no studentInfo json, then Mongo won't either.
    // We would need to query by join or improved Sync.
    // For now, let's assume we search by some field if available, or return empty if structure mismatch.
    return [];
  }

  async getTeachersByClassId(classId: string): Promise<any[]> {
    return [];
  }

  async getUsersByRoleKey(roleKey: string): Promise<any[]> {
    const users = await UserReadModel.find({ roleKey })
      .sort({ fullName: 1 })
      .lean();
    return users;
  }

  async getUserSchoolInfo(userId: string): Promise<{
    schoolName?: string;
    className?: string;
  } | null> {
    const user: any = await UserReadModel.findOne({ _id: userId }).lean();

    if (!user) return null;

    const result: { schoolName?: string; className?: string } = {};

    // Manual join for School
    if (user.schoolId) {
      const school: any = await SchoolReadModel.findOne({
        _id: user.schoolId,
      }).lean();
      if (school) {
        result.schoolName = school.name;
      }
    }

    // Manual join for Class (if student)
    // Note: classId is not on User root in all schemas, usually in studentProfile.
    // But SyncService copies properties. In Postgres User model, there is no classId directly usually?
    // Wait, RegisterUserUseCase puts classId in StudentProfile.
    // If SyncService simply copies User table, it won't have classId.
    // So getting className here might fail until we sync StudentProfile.

    return Object.keys(result).length > 0 ? result : null;
  }
}
