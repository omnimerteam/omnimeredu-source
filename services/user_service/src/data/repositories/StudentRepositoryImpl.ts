import { IStudentRepository } from "../../domain/repositories/IStudentRepository";
import { Student } from "../../domain/entities/Student";
import { StudentModel } from "../datasources/postgres/models/StudentModel";
import { Op } from "sequelize";

export class StudentRepositoryImpl implements IStudentRepository {
  async create(student: Student): Promise<Student> {
    const model = await StudentModel.create({
      userId: student.userId,
      classId: student.classId,
      educationLevel: student.educationLevel,
      gradeGroup: student.gradeGroup,
      guardianName: student.guardianName,
      guardianPhone: student.guardianPhone,
      meta: student.meta,
    });
    return this.toEntity(model);
  }

  async findById(id: string): Promise<Student | null> {
    const model = await StudentModel.findByPk(id);
    if (!model) return null;
    return this.toEntity(model);
  }

  async findByUserId(userId: string): Promise<Student | null> {
    const model = await StudentModel.findOne({ where: { userId } });
    if (!model) return null;
    return this.toEntity(model);
  }

  async findByClassId(classId: string): Promise<Student[]> {
    const models = await StudentModel.findAll({
      where: { classId },
      order: [["guardianName", "ASC"]],
    });
    return models.map((model) => this.toEntity(model));
  }

  async update(student: Student): Promise<Student> {
    const [affectedCount, updatedModels] = await StudentModel.update(
      {
        userId: student.userId,
        classId: student.classId,
        educationLevel: student.educationLevel,
        gradeGroup: student.gradeGroup,
        guardianName: student.guardianName,
        guardianPhone: student.guardianPhone,
        meta: student.meta,
      },
      {
        where: { id: student.id },
        returning: true,
      }
    );

    if (affectedCount === 0 || !updatedModels[0]) {
      throw new Error("Student not found or not updated");
    }

    return this.toEntity(updatedModels[0]);
  }

  async delete(id: string): Promise<boolean> {
    const deletedCount = await StudentModel.destroy({ where: { id } });
    return deletedCount > 0;
  }

  async updateClassForStudents(
    studentIds: string[],
    classId: string | null
  ): Promise<void> {
    await StudentModel.update(
      { classId },
      {
        where: {
          id: {
            [Op.in]: studentIds,
          },
        },
      }
    );
  }

  async countStudentsInClass(classId: string): Promise<number> {
    return await StudentModel.count({
      where: {
        classId,
      },
    });
  }

  async findStudentsByParentId(parentId: string): Promise<Student[]> {
    // Note: parentId is not currently in the StudentModel schema.
    // This implementation returns an empty array to satisfy the interface.
    return [];
  }

  private toEntity(model: StudentModel): Student {
    return new Student(
      model.id,
      model.userId,
      model.educationLevel,
      model.gradeGroup,
      model.classId,
      model.guardianName,
      model.guardianPhone,
      model.meta,
      model.createdAt,
      model.updatedAt
    );
  }
}
