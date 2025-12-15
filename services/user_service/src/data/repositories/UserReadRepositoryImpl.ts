import { IUserReadRepository } from "../../domain/repositories/IUserReadRepository";
import { UserFullReadModel } from "../datasources/mongodb/schemas/UserFullReadSchema";

export class UserReadRepositoryImpl implements IUserReadRepository {
  async getUserFullInfo(userId: string): Promise<any> {
    const user = await UserFullReadModel.findOne({ _id: userId }).lean();
    return user;
  }

  async getUserFullInfoByEmail(email: string): Promise<any> {
    const user = await UserFullReadModel.findOne({ email }).lean();
    return user;
  }

  async getUsersBySchoolId(schoolId: string): Promise<any[]> {
    const users = await UserFullReadModel.find({ schoolId })
      .sort({ fullName: 1 })
      .lean();
    return users;
  }

  async getStudentsByClassId(classId: string): Promise<any[]> {
    const students = await UserFullReadModel.find({
      roleKey: "Student",
      "studentInfo.classId": classId,
    })
      .sort({ fullName: 1 })
      .lean();
    return students;
  }

  async getTeachersByClassId(classId: string): Promise<any[]> {
    const teachers = await UserFullReadModel.find({
      roleKey: "Teacher",
      "teacherInfo.classIds": classId,
    })
      .sort({ fullName: 1 })
      .lean();
    return teachers;
  }

  async getUsersByRoleKey(roleKey: string): Promise<any[]> {
    const users = await UserFullReadModel.find({ roleKey })
      .sort({ fullName: 1 })
      .lean();
    return users;
  }

  async getUserSchoolInfo(userId: string): Promise<{
    schoolName?: string;
    className?: string;
  } | null> {
    const user = await UserFullReadModel.findOne({ _id: userId })
      .select("school studentInfo")
      .lean();

    if (!user) return null;

    const result: { schoolName?: string; className?: string } = {};

    // Get school name from denormalized data
    if (user.school?.name) {
      result.schoolName = user.school.name;
    }

    // Get class name for students from denormalized data
    if (user.studentInfo?.class?.name) {
      result.className = user.studentInfo.class.name;
    }

    return Object.keys(result).length > 0 ? result : null;
  }
}
