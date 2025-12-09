import { IGradeRepository } from "../../domain/repositories/IGradeRepository";
import { Grade } from "../../domain/entities/Grade";
import { GradeModel } from "../datasources/postgres/models/GradeModel";

export class GradeRepositoryImpl implements IGradeRepository {
  async create(grade: Grade): Promise<Grade> {
    const model = await GradeModel.create({
      schoolId: grade.schoolId,
      name: grade.name,
      level: grade.level,
      gradeGroup: grade.gradeGroup,
      order: grade.order,
      active: grade.active,
      ageRange: grade.ageRange,
      description: grade.description,
      customFields: grade.customFields,
    });
    return this.toEntity(model);
  }

  async findById(id: string): Promise<Grade | null> {
    const model = await GradeModel.findByPk(id);
    if (!model) return null;
    return this.toEntity(model);
  }

  async findBySchoolId(schoolId: string): Promise<Grade[]> {
    const models = await GradeModel.findAll({ where: { schoolId } });
    return models.map((model) => this.toEntity(model));
  }

  async update(grade: Grade): Promise<Grade> {
    const [affectedCount, updatedModels] = await GradeModel.update(
      {
        schoolId: grade.schoolId,
        name: grade.name,
        level: grade.level,
        gradeGroup: grade.gradeGroup,
        order: grade.order,
        active: grade.active,
        ageRange: grade.ageRange,
        description: grade.description,
        customFields: grade.customFields,
      },
      {
        where: { id: grade.id },
        returning: true,
      }
    );

    if (affectedCount === 0 || !updatedModels[0]) {
      throw new Error("Grade not found or not updated");
    }

    return this.toEntity(updatedModels[0]);
  }

  async delete(id: string): Promise<boolean> {
    const deletedCount = await GradeModel.destroy({ where: { id } });
    return deletedCount > 0;
  }

  private toEntity(model: GradeModel): Grade {
    return new Grade(
      model.id,
      model.schoolId,
      model.name,
      model.level,
      model.gradeGroup,
      model.order,
      model.active,
      model.ageRange,
      model.description,
      model.customFields,
      model.createdAt,
      model.updatedAt
    );
  }
}
