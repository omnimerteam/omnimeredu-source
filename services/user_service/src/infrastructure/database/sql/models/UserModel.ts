import { Model, DataTypes } from "sequelize";
import { sequelize } from "../config";

export class UserModel extends Model {
  public id!: string;
  public fullName!: string;
  public roleKey!: string;
  public email?: string;
  public gender?: string;
  public birthday?: Date;
  public phone?: string;
  public address?: string;
  public isVerified!: boolean;
  public avatarUrl?: string;
  public schoolId?: string;
  public deletedAt?: Date | null;
}

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
      type: DataTypes.STRING,
      allowNull: false,
      field: "role_key",
    },
    email: {
      type: DataTypes.STRING,
      allowNull: true,
    },
    gender: {
      type: DataTypes.STRING,
      allowNull: true,
    },
    birthday: {
      type: DataTypes.DATEONLY,
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
      type: DataTypes.STRING, // Assuming UUID or similar
      allowNull: true,
      field: "school_id",
    },
    deletedAt: {
      type: DataTypes.DATE,
      allowNull: true,
      field: "deleted_at",
    },
  },
  {
    sequelize,
    tableName: "users",
    timestamps: true,
    paranoid: true, // Enable soft delete natively in Sequelize
  }
);
