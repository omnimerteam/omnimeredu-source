import { IGradeRepository, FilterOptions, GradeSelectOption } from "../../domain/repositories/IGradeRepository";
import { Grade } from "../../domain/entities/Grade";
import { GradeModel } from "../datasources/postgres/models/GradeModel";
import { Op } from "sequelize";

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

  async findAllWithPagination(
    skip: number,
    limit: number,
    sortBy: string,
    sortOrder: 'asc' | 'desc',
    filters: FilterOptions,
    fields?: string[]
  ): Promise<Grade[]> {
    const whereClause: any = {};

    // Build where clause with enhanced filters
    if (filters.schoolId) whereClause.schoolId = filters.schoolId;
    if (filters.level !== undefined) whereClause.level = filters.level;
    if (filters.active !== undefined) whereClause.active = filters.active;

    // Add search filters
    if (filters.search) {
      whereClause[Op.or] = [
        { name: { [Op.iLike]: `%${filters.search}%` } },
        { description: { [Op.iLike]: `%${filters.search}%` } }
      ];
    }

    if (filters.name) {
      whereClause.name = { [Op.iLike]: `%${filters.name}%` };
    }

    // Build attributes for field selection
    const attributes = fields && fields.length > 0 ? fields : undefined;

    const models = await GradeModel.findAll({
      where: whereClause,
      offset: skip,
      limit: limit,
      attributes,
      order: [
        [sortBy, sortOrder.toUpperCase() as 'ASC' | 'DESC'],
        ['id', sortOrder.toUpperCase() as 'ASC' | 'DESC'] // Secondary sort for consistency
      ],
      distinct: true
    });

    return models.map((model) => this.toEntity(model));
  }

  async count(filters: FilterOptions): Promise<number> {
    const whereClause: any = {};

    if (filters.schoolId) whereClause.schoolId = filters.schoolId;
    if (filters.level !== undefined) whereClause.level = filters.level;
    if (filters.active !== undefined) whereClause.active = filters.active;

    // Add search filters to count as well
    if (filters.search) {
      whereClause[Op.or] = [
        { name: { [Op.iLike]: `%${filters.search}%` } },
        { description: { [Op.iLike]: `%${filters.search}%` } }
      ];
    }

    if (filters.name) {
      whereClause.name = { [Op.iLike]: `%${filters.name}%` };
    }

    return await GradeModel.count({ where: whereClause });
  }

  async findForSelect(schoolId?: string): Promise<GradeSelectOption[]> {
    const whereClause: any = { active: true };
    if (schoolId) whereClause.schoolId = schoolId;

    const models = await GradeModel.findAll({
      where: whereClause,
      attributes: ['id', 'name', 'level', 'schoolId'],
      order: [['level', 'ASC'], ['name', 'ASC']]
    });

    return models.map((model) => ({
      _id: model.id,
      name: model.name,
      level: model.level,
      schoolId: model.schoolId
    }));
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
