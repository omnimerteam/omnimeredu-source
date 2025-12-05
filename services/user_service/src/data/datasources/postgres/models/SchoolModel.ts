import { DataTypes, Model, Sequelize } from "sequelize";
import { EducationSystemLevelsEnum } from "shared-lib";
import { UserModel } from "./UserModel";

export class SchoolModel extends Model {
  public id!: string;
  public name!: string;
  public code!: string;
  public address!: string;
  public level!: EducationSystemLevelsEnum;
  public adminId?: string;
  public phone?: string;
  public description?: string;
  public logoUrl?: string;
  public studentCount!: number;
  public customTheme?: object;

  public readonly createdAt!: Date;
  public readonly updatedAt!: Date;
}

export const initSchoolModel = (sequelize: Sequelize) => {
  SchoolModel.init(
    {
      id: {
        type: DataTypes.UUID,
        defaultValue: DataTypes.UUIDV4,
        primaryKey: true,
      },
      name: {
        type: DataTypes.STRING,
        allowNull: false,
      },
      code: {
        type: DataTypes.STRING,
        allowNull: false,
        unique: true,
      },
      address: {
        type: DataTypes.STRING,
        allowNull: false,
      },
      level: {
        type: DataTypes.ENUM(...Object.values(EducationSystemLevelsEnum)),
        allowNull: false,
      },
      adminId: {
        type: DataTypes.UUID,
        allowNull: true,
        field: "admin_id",
        references: {
          model: "users",
          key: "id",
        },
      },
      phone: {
        type: DataTypes.STRING,
        allowNull: true,
      },
      description: {
        type: DataTypes.TEXT,
        allowNull: true,
      },
      logoUrl: {
        type: DataTypes.STRING,
        allowNull: true,
        field: "logo_url",
      },
      studentCount: {
        type: DataTypes.INTEGER,
        defaultValue: 0,
        field: "student_count",
      },
      customTheme: {
        type: DataTypes.JSONB,
        allowNull: true,
        field: "custom_theme",
      },
    },
    {
      sequelize,
      tableName: "schools",
      timestamps: true,
      underscored: true,
    }
  );
};
