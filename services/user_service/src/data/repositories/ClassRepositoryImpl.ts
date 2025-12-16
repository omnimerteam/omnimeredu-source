import { IClassRepository, ClassFilterOptions, SearchClassesOptions } from "../../domain/repositories/IClassRepository";
import { Class } from "../../domain/entities/Class";
import { ClassModel } from "../datasources/postgres/models/ClassModel";
import { Op } from "sequelize";

export class ClassRepositoryImpl implements IClassRepository {
  async create(classEntity: Class): Promise<Class> {
    const model = await ClassModel.create({
      name: classEntity.name,
      code: classEntity.code,
      schoolId: classEntity.schoolId,
      gradeId: classEntity.gradeId,
      maxStudents: classEntity.maxStudents,
      baseFee: classEntity.baseFee,
    });
    return this.toEntity(model);
  }

  async findById(id: string): Promise<Class | null> {
    const model = await ClassModel.findByPk(id);
    if (!model) return null;
    return this.toEntity(model);
  }

  async findByCode(code: string): Promise<Class | null> {
    const model = await ClassModel.findOne({ where: { code } });
    if (!model) return null;
    return this.toEntity(model);
  }

  async findBySchoolId(schoolId: string): Promise<Class[]> {
    const models = await ClassModel.findAll({ where: { schoolId } });
    return models.map((model) => this.toEntity(model));
  }

  async update(classEntity: Class): Promise<Class> {
    const [affectedCount, updatedModels] = await ClassModel.update(
      {
        name: classEntity.name,
        code: classEntity.code,
        schoolId: classEntity.schoolId,
        gradeId: classEntity.gradeId,
        maxStudents: classEntity.maxStudents,
        baseFee: classEntity.baseFee,
      },
      {
        where: { id: classEntity.id },
        returning: true,
      }
    );

    if (affectedCount === 0 || !updatedModels[0]) {
      throw new Error("Class not found or not updated");
    }

    return this.toEntity(updatedModels[0]);
  }

  async delete(id: string): Promise<boolean> {
    const deletedCount = await ClassModel.destroy({ where: { id } });
    return deletedCount > 0;
  }

  async getClassesBySchool(params: {
    schoolId: string;
    grade?: string;
  }): Promise<any[]> {
    const { SchoolModel } = await import(
      "../datasources/postgres/models/SchoolModel"
    );

    const whereCondition: any = {
      schoolId: params.schoolId,
      deletedAt: null,
    };

    // Add grade filter if provided
    if (params.grade) {
      whereCondition.grade = params.grade;
    }

    const classes = await ClassModel.findAll({
      where: whereCondition,
      include: [
        {
          model: SchoolModel,
          as: "school",
          attributes: ["id", "name", "level"],
        },
      ],
      order: [["name", "ASC"]],
    });

    return classes.map((cls) => {
      const clsAny = cls as any;
      return {
        id: cls.id,
        name: cls.name,
        code: cls.code,
        schoolId: cls.schoolId,
        grade: cls.gradeId,
        level: clsAny.school?.level || "",
        maxStudents: cls.maxStudents,
        currentStudents: clsAny.currentStudents || 0,
        createdAt: cls.createdAt,
        updatedAt: cls.updatedAt,
      };
    });
  }

  async findAllWithPagination(
    skip: number,
    limit: number,
    sortBy: string,
    sortOrder: 'asc' | 'desc',
    filters: ClassFilterOptions
  ): Promise<Class[]> {
    const whereClause: any = {};

    if (filters.schoolId) whereClause.schoolId = filters.schoolId;
    if (filters.gradeId) whereClause.gradeId = filters.gradeId;
    if (filters.maxStudents) whereClause.maxStudents = filters.maxStudents;
    if (filters.active !== undefined) whereClause.active = filters.active;

    const models = await ClassModel.findAll({
      where: whereClause,
      offset: skip,
      limit: limit,
      order: [[sortBy, sortOrder.toUpperCase() as 'ASC' | 'DESC']]
    });

    return models.map((model) => this.toEntity(model));
  }

  async count(filters: ClassFilterOptions): Promise<number> {
    const whereClause: any = {};

    if (filters.schoolId) whereClause.schoolId = filters.schoolId;
    if (filters.gradeId) whereClause.gradeId = filters.gradeId;
    if (filters.maxStudents) whereClause.maxStudents = filters.maxStudents;
    if (filters.active !== undefined) whereClause.active = filters.active;

    return await ClassModel.count({ where: whereClause });
  }

  async searchClasses(options: SearchClassesOptions): Promise<Class[]> {
    const { query, schoolId, gradeId, limit = 20, offset = 0 } = options;

    const whereClause: any = {};

    if (query) {
      whereClause[Op.or] = [
        { name: { [Op.iLike]: `%${query}%` } },
        { code: { [Op.iLike]: `%${query}%` } }
      ];
    }

    if (schoolId) whereClause.schoolId = schoolId;
    if (gradeId) whereClause.gradeId = gradeId;

    const models = await ClassModel.findAll({
      where: whereClause,
      limit,
      offset,
      order: [['name', 'ASC']]
    });

    return models.map((model) => this.toEntity(model));
  }

  private toEntity(model: ClassModel): Class {
    return new Class(
      model.id,
      model.name,
      model.code,
      model.schoolId,
      model.gradeId,
      model.maxStudents,
      model.baseFee,
      [], // Students list not loaded by default in simple CRUD
      model.createdAt,
      model.updatedAt
    );
  }
}
