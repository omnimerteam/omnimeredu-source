import { DataTypes, Model, Sequelize } from "sequelize";
import { EducationSystemLevelsEnum, EducationGradesEnum } from "shared-lib";

export class StudentModel extends Model {
  public id!: string;
  public userId!: string;
  public classId?: string;
  public educationLevel!: EducationSystemLevelsEnum;
  public gradeGroup!: EducationGradesEnum;
  public guardianName?: string;
  public guardianPhone?: string;
  public meta?: any;

  public readonly createdAt!: Date;
  public readonly updatedAt!: Date;
}

export const initStudentModel = (sequelize: Sequelize) => {
  StudentModel.init(
    {
      id: {
        type: DataTypes.UUID,
        defaultValue: DataTypes.UUIDV4,
        primaryKey: true,
      },
      userId: {
        type: DataTypes.UUID,
        allowNull: false,
        unique: true,
        field: "user_id",
        references: {
          model: "users",
          key: "id",
        },
      },
      classId: {
        type: DataTypes.STRING,
        allowNull: true,
        field: "class_id",
      },
      educationLevel: {
        type: DataTypes.ENUM(...Object.values(EducationSystemLevelsEnum)),
        allowNull: false,
        field: "education_level",
      },
      gradeGroup: {
        type: DataTypes.ENUM(...Object.values(EducationGradesEnum)),
        allowNull: false,
        field: "grade_group",
      },
      guardianName: {
        type: DataTypes.STRING,
        allowNull: true,
        field: "guardian_name",
      },
      guardianPhone: {
        type: DataTypes.STRING,
        allowNull: true,
        field: "guardian_phone",
      },
      meta: {
        type: DataTypes.JSONB,
        allowNull: true,
        defaultValue: {},
      },
    },
    {
      sequelize,
      tableName: "students",
      timestamps: true,
      underscored: true,
    }
  );
};
