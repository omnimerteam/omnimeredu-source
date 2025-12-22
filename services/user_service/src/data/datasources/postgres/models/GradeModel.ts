import { DataTypes, Model, Sequelize } from "shared-lib";
import { EducationSystemLevelsEnum, EducationGradesEnum } from "shared-lib";

export class GradeModel extends Model {
  public id!: string;
  public schoolId!: string;
  public name!: string;
  public level!: EducationSystemLevelsEnum;
  public gradeGroup!: EducationGradesEnum;
  public order!: number;
  public active!: boolean;
  public ageRange?: { min?: number; max?: number };
  public description?: string;
  public customFields?: object;

  public readonly createdAt!: Date;
  public readonly updatedAt!: Date;
}

export const initGradeModel = (sequelize: Sequelize) => {
  GradeModel.init(
    {
      id: {
        type: DataTypes.UUID,
        defaultValue: DataTypes.UUIDV4,
        primaryKey: true,
      },
      schoolId: {
        type: DataTypes.UUID,
        allowNull: false,
        field: "school_id",
        references: {
          model: "schools",
          key: "id",
        },
      },
      name: {
        type: DataTypes.STRING,
        allowNull: false,
      },
      level: {
        type: DataTypes.ENUM(...Object.values(EducationSystemLevelsEnum)),
        allowNull: false,
      },
      gradeGroup: {
        type: DataTypes.ENUM(...Object.values(EducationGradesEnum)),
        allowNull: false,
        field: "grade_group",
      },
      order: {
        type: DataTypes.INTEGER,
        allowNull: false,
      },
      active: {
        type: DataTypes.BOOLEAN,
        defaultValue: true,
      },
      ageRange: {
        type: DataTypes.JSONB,
        allowNull: true,
        field: "age_range",
      },
      description: {
        type: DataTypes.TEXT,
        allowNull: true,
      },
      customFields: {
        type: DataTypes.JSONB,
        allowNull: true,
        defaultValue: {},
        field: "custom_fields",
      },
    },
    {
      sequelize,
      tableName: "grades",
      timestamps: true,
      underscored: true,
    }
  );
};
