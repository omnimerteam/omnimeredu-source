import { DataTypes, Model, Sequelize } from "shared-lib";
import { RoleEnum, RoleGroup } from "shared-lib";

export class RoleModel extends Model {
  public id!: string;
  public name!: RoleEnum;
  public group!: RoleGroup;
  public description?: string;
  public permissions?: string[];

  public readonly createdAt!: Date;
  public readonly updatedAt!: Date;
}

export const initRoleModel = (sequelize: Sequelize) => {
  RoleModel.init(
    {
      id: {
        type: DataTypes.UUID,
        defaultValue: DataTypes.UUIDV4,
        primaryKey: true,
      },
      name: {
        type: DataTypes.ENUM(...Object.values(RoleEnum)),
        allowNull: false,
        unique: true,
      },
      group: {
        type: DataTypes.ENUM(...Object.values(RoleGroup)),
        allowNull: false,
      },
      description: {
        type: DataTypes.STRING,
        allowNull: true,
      },
      permissions: {
        type: DataTypes.ARRAY(DataTypes.STRING),
        allowNull: true,
        defaultValue: [],
      },
    },
    {
      sequelize,
      tableName: "roles",
      timestamps: true,
      underscored: true,
    }
  );
};
