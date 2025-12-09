import { DataTypes, Model, Sequelize } from "sequelize";
import { SchoolAdminPositionEnum } from "shared-lib";

export class SchoolAdminModel extends Model {
  public id!: string;
  public userId!: string;
  public position?: SchoolAdminPositionEnum;

  public readonly createdAt!: Date;
  public readonly updatedAt!: Date;
}

export const initSchoolAdminModel = (sequelize: Sequelize) => {
  SchoolAdminModel.init(
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
      position: {
        type: DataTypes.ENUM(...Object.values(SchoolAdminPositionEnum)),
        allowNull: true,
      },
    },
    {
      sequelize,
      tableName: "school_admins",
      timestamps: true,
      underscored: true,
    }
  );
};
