import { Model, DataTypes } from "sequelize";
import { sequelize } from "../config";
import { UserModel } from "./UserModel";

export class AccountModel extends Model {
  public id!: string;
  public userId!: string;
  public email!: string;
  public passwordHash!: string;
  public uid!: string;
  public isActive!: boolean;
  public lastLogin?: Date;
}

AccountModel.init(
  {
    id: {
      type: DataTypes.UUID,
      defaultValue: DataTypes.UUIDV4,
      primaryKey: true,
    },
    userId: {
      type: DataTypes.UUID,
      allowNull: false,
      field: "user_id",
      references: {
        model: UserModel,
        key: "id",
      },
    },
    email: {
      type: DataTypes.STRING,
      allowNull: false,
      unique: true,
    },
    passwordHash: {
      type: DataTypes.STRING,
      allowNull: false,
      field: "password_hash",
    },
    uid: {
      type: DataTypes.STRING,
      allowNull: false,
      unique: true,
    },
    isActive: {
      type: DataTypes.BOOLEAN,
      defaultValue: true,
      field: "is_active",
    },
    lastLogin: {
      type: DataTypes.DATE,
      allowNull: true,
      field: "last_login",
    },
  },
  {
    sequelize,
    tableName: "accounts",
    timestamps: true,
  }
);

// Define association
UserModel.hasOne(AccountModel, { foreignKey: "userId", as: "account" });
AccountModel.belongsTo(UserModel, { foreignKey: "userId", as: "user" });
