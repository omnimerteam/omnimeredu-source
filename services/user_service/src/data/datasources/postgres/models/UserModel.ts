import { DataTypes, Model, Sequelize } from "sequelize";
import { GenderEnum, RoleGroup } from "shared-lib";

export class UserModel extends Model {
  public id!: string;
  public fullName!: string;
  public roleKey!: RoleGroup;
  public email?: string;
  public gender?: GenderEnum;
  public birthday?: Date;
  public phone?: string;
  public address?: string;
  public isVerified!: boolean;
  public avatarUrl?: string;
  public schoolId?: string;

  public readonly createdAt!: Date;
  public readonly updatedAt!: Date;
  public readonly deletedAt?: Date;
}

export const initUserModel = (sequelize: Sequelize) => {
  UserModel.init(
    {
      id: {
        type: DataTypes.UUID,
        defaultValue: DataTypes.UUIDV4,
        primaryKey: true,
      },
      fullName: {
        type: DataTypes.STRING,
        allowNull: false,
        field: "full_name",
      },
      roleKey: {
        type: DataTypes.ENUM(...Object.values(RoleGroup)),
        allowNull: false,
        defaultValue: RoleGroup.Staff,
        field: "role_key",
      },
      email: {
        type: DataTypes.STRING,
        allowNull: true,
      },
      gender: {
        type: DataTypes.ENUM(...Object.values(GenderEnum)),
        allowNull: true,
      },
      birthday: {
        type: DataTypes.DATE,
        allowNull: true,
      },
      phone: {
        type: DataTypes.STRING,
        allowNull: true,
      },
      address: {
        type: DataTypes.STRING,
        allowNull: true,
      },
      isVerified: {
        type: DataTypes.BOOLEAN,
        defaultValue: false,
        field: "is_verified",
      },
      avatarUrl: {
        type: DataTypes.STRING,
        allowNull: true,
        field: "avatar_url",
      },
      schoolId: {
        type: DataTypes.UUID,
        allowNull: true,
        field: "school_id",
      },
    },
    {
      sequelize,
      tableName: "users",
      paranoid: true, // Enables soft deletes (deletedAt)
      timestamps: true,
      underscored: true, // Ensure timestamps are also snake_case (created_at, updated_at)
    }
  );
};
