import { DataTypes, Model, Sequelize } from "shared-lib";

export class SuperAdminModel extends Model {
  public id!: string;
  public userId!: string;

  public readonly createdAt!: Date;
  public readonly updatedAt!: Date;
}

export const initSuperAdminModel = (sequelize: Sequelize) => {
  SuperAdminModel.init(
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
    },
    {
      sequelize,
      tableName: "super_admins",
      timestamps: true,
      underscored: true,
    }
  );
};
