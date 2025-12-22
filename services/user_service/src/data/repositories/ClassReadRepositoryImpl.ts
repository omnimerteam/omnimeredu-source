import { IClassReadRepository } from "../../domain/repositories/IClassReadRepository";
import { ClassModel } from "../datasources/postgres/models/ClassModel";
import { StudentModel } from "../datasources/postgres/models/StudentModel";
import { UserModel } from "../datasources/postgres/models/UserModel";

export class ClassReadRepositoryImpl implements IClassReadRepository {
  async findById(id: string): Promise<any> {
    const classEntity = await ClassModel.findByPk(id);
    return classEntity ? classEntity.get({ plain: true }) : null;
  }

  async findBySchoolId(schoolId: string): Promise<any[]> {
    const classes = await ClassModel.findAll({
      where: { schoolId },
      order: [["name", "ASC"]],
    });
    return classes.map((c) => c.get({ plain: true }));
  }

  async findByGradeId(gradeId: string): Promise<any[]> {
    const classes = await ClassModel.findAll({
      where: { gradeId },
      order: [["name", "ASC"]],
    });
    return classes.map((c) => c.get({ plain: true }));
  }

  async findStudentsByClassId(classId: string): Promise<any[]> {
    // Query students from PostgreSQL with join to User
    const students = await StudentModel.findAll({
      where: { classId },
      include: [
        {
          model: UserModel,
          as: "user",
          attributes: ["id", "fullName", "email", "avatarUrl"],
        },
      ],
    });

    // Map to expected format
    return students.map((student) => {
      const studentData = student.get({ plain: true }) as any;
      return {
        _id: studentData.user?.id || studentData.userId,
        id: studentData.user?.id || studentData.userId,
        fullName: studentData.user?.fullName || "Unknown",
        email: studentData.user?.email,
        avatar: studentData.user?.avatarUrl,
        student: {
          id: studentData.id,
          classId: studentData.classId,
          educationLevel: studentData.educationLevel,
          gradeGroup: studentData.gradeGroup,
          guardianName: studentData.guardianName,
          guardianPhone: studentData.guardianPhone,
        },
      };
    });
  }
}
