import {
  ISchoolRepository,
  SearchSchoolsOptions,
} from "../../domain/repositories/ISchoolRepository";
import { School } from "../../domain/entities/School";
import { SchoolModel } from "../datasources/postgres/models/SchoolModel";
import { SchoolAdminModel } from "../datasources/postgres/models/SchoolAdminModel";
import { Op } from "sequelize";
import { EducationSystemLevelsEnum } from "shared-lib";

export class SchoolRepositoryImpl implements ISchoolRepository {
  async create(school: School): Promise<School> {
    const model = await SchoolModel.create({
      name: school.name,
      code: school.code,
      address: school.address,
      level: school.level,
      adminId: school.adminId,
      phone: school.phone,
      description: school.description,
      logoUrl: school.logoUrl,
      studentCount: school.studentCount,
      customTheme: school.customTheme,
    });
    return this.toEntity(model);
  }

  async findById(id: string): Promise<School | null> {
    const model = await SchoolModel.findByPk(id);
    if (!model) return null;
    return this.toEntity(model);
  }

  async findByCode(code: string): Promise<School | null> {
    const model = await SchoolModel.findOne({ where: { code } });
    if (!model) return null;
    return this.toEntity(model);
  }

  async update(school: School): Promise<School> {
    const [affectedCount, updatedModels] = await SchoolModel.update(
      {
        name: school.name,
        code: school.code,
        address: school.address,
        level: school.level,
        adminId: school.adminId,
        phone: school.phone,
        description: school.description,
        logoUrl: school.logoUrl,
        studentCount: school.studentCount,
        customTheme: school.customTheme,
      },
      {
        where: { id: school.id },
        returning: true,
      }
    );

    if (affectedCount === 0 || !updatedModels[0]) {
      throw new Error("School not found or not updated");
    }

    return this.toEntity(updatedModels[0]);
  }

  async delete(id: string): Promise<boolean> {
    const deletedCount = await SchoolModel.destroy({ where: { id } });
    return deletedCount > 0;
  }

  async getSchoolsByLevel(params: {
    educationLevel: EducationSystemLevelsEnum;
    search?: string;
  }): Promise<School[]> {
    const whereCondition: any = {
      level: params.educationLevel,
      // deletedAt: null, // Removed because SchoolModel does not have paranoid: true enabled
    };

    // Add search condition if provided
    if (params.search) {
      whereCondition[Op.or] = [
        {
          name: {
            [Op.iLike]: `%${params.search}%`,
          },
        },
        {
          code: {
            [Op.iLike]: `%${params.search}%`,
          },
        },
      ];
    }

    const schools = await SchoolModel.findAll({
      where: whereCondition,
      order: [["name", "ASC"]],
      attributes: { exclude: ["customTheme"] },
    });

    return schools.map((school) => this.toEntity(school));
  }

  async searchSchools(options: SearchSchoolsOptions): Promise<School[]> {
    const { educationLevel, search, limit = 20, offset = 0 } = options;

    const whereClause: any = {};

    if (educationLevel) {
      whereClause.level = educationLevel;
    }

    if (search) {
      whereClause[Op.or] = [
        { name: { [Op.iLike]: `%${search}%` } },
        { code: { [Op.iLike]: `%${search}%` } },
      ];
    }

    const models = await SchoolModel.findAll({
      where: whereClause,
      limit,
      offset,
      order: [["name", "ASC"]],
      attributes: { exclude: ["customTheme"] },
    });

    return models.map((model) => this.toEntity(model));
  }

  async findSchoolAdminByUserId(
    userId: string
  ): Promise<{ schoolId: string } | null> {
    const school = await SchoolModel.findOne({
      where: { adminId: userId },
      attributes: ["id"],
    });

    if (!school) {
      return null;
    }

    return {
      schoolId: school.id,
    };
  }

  private toEntity(model: SchoolModel): School {
    return new School(
      model.id,
      model.name,
      model.code,
      model.address,
      model.level,
      model.adminId,
      model.phone,
      model.description,
      model.logoUrl,
      model.studentCount,
      model.customTheme,
      model.createdAt,
      model.updatedAt
    );
  }
}
