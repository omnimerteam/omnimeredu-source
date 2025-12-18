import { DataTypes, Model, Sequelize } from "shared-lib";

export class ClassModel extends Model {
  public id!: string;
  public name!: string;
  public code!: string;
  public schoolId!: string;
  public gradeId!: string;
  public maxStudents!: number;
  public baseFee!: number;

  public readonly createdAt!: Date;
  public readonly updatedAt!: Date;

  // Association
  public grade?: any; // or GradeModel if cyclic dependency can be managed, effectively avoiding import cycle issues for now
}

export const initClassModel = (sequelize: Sequelize) => {
  ClassModel.init(
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
      schoolId: {
        type: DataTypes.UUID,
        allowNull: false,
        field: "school_id",
        references: {
          model: "schools",
          key: "id",
        },
      },
      gradeId: {
        type: DataTypes.UUID,
        allowNull: false,
        field: "grade_id",
        references: {
          model: "grades",
          key: "id",
        },
      },
      maxStudents: {
        type: DataTypes.INTEGER,
        defaultValue: 30,
        field: "max_students",
      },
      baseFee: {
        type: DataTypes.FLOAT,
        defaultValue: 0,
        field: "base_fee",
      },
    },
    {
      sequelize,
      tableName: "classes",
      timestamps: true,
      underscored: true,
      indexes: [
        {
          fields: ["school_id"],
        },
        {
          fields: ["grade_id"],
        },
      ],
    }
  );
};
