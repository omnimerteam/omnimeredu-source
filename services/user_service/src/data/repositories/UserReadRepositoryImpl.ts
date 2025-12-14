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

  async getUserFullInfoByUid(uid: string): Promise<any> {
    const user = await UserFullReadModel.findOne({ "account.uid": uid }).lean();
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
      .select("schoolInfo studentInfo.classId teacherInfo.classIds")
      .populate({
        path: "schoolInfo.schoolId",
        select: "name",
      })
      .populate({
        path: "studentInfo.classId",
        select: "name",
      })
      .lean();

    if (!user) return null;

    const result: { schoolName?: string; className?: string } = {};

    // Get school name
    if (user.schoolInfo?.schoolId) {
      result.schoolName = (user.schoolInfo.schoolId as any).name;
    }

    // Get class name for students
    if (user.studentInfo?.classId) {
      result.className = (user.studentInfo.classId as any).name;
    }

    return Object.keys(result).length > 0 ? result : null;
  }
}
