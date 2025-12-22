import { DataTypes, Model, Sequelize } from "shared-lib";
import { TeacherQualificationEnum, SubjectEnum } from "shared-lib";

export class TeacherModel extends Model {
  public id!: string;
  public userId!: string;
  public qualification?: TeacherQualificationEnum;
  public subjects?: SubjectEnum[];

  public readonly createdAt!: Date;
  public readonly updatedAt!: Date;
}

export const initTeacherModel = (sequelize: Sequelize) => {
  TeacherModel.init(
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
      qualification: {
        type: DataTypes.ENUM(...Object.values(TeacherQualificationEnum)),
        allowNull: true,
      },
      subjects: {
        type: DataTypes.ARRAY(DataTypes.STRING), // Using ARRAY of STRINGs for subjects
        allowNull: true,
        defaultValue: [],
      },
    },
    {
      sequelize,
      tableName: "teachers",
      timestamps: true,
      underscored: true,
    }
  );
};
