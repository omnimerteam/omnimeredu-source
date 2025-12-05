import { Model, DataTypes } from "sequelize";
import { sequelize } from "../config";
import { UserModel } from "./UserModel";

export class StudentModel extends Model {
  public id!: string; // Same as User ID or separate? Usually separate PK, FK to User
  public userId!: string;
  public classId?: string;
  public educationLevel!: string;
  public gradeGroup!: string;
  public guardianName?: string;
  public guardianPhone?: string;
  public meta?: any;
}

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
      unique: true, // One User is One Student (if role matches)
      field: "user_id",
      references: {
        model: UserModel,
        key: "id",
      },
    },
    classId: {
      type: DataTypes.STRING,
      allowNull: true,
      field: "class_id",
    },
    educationLevel: {
      type: DataTypes.STRING,
      allowNull: false,
      field: "education_level",
    },
    gradeGroup: {
      type: DataTypes.STRING,
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
      type: DataTypes.JSONB, // Use JSONB for flexible meta
      allowNull: true,
      defaultValue: {},
    },
  },
  {
    sequelize,
    tableName: "students",
    timestamps: true,
  }
);

// Association
UserModel.hasOne(StudentModel, { foreignKey: "userId", as: "studentProfile" });
StudentModel.belongsTo(UserModel, { foreignKey: "userId", as: "user" });
