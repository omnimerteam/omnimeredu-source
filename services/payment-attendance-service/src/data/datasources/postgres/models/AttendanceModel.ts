import { DataTypes, Model, Sequelize } from "shared-lib";

export class AttendanceModel extends Model {
  public id!: string;
  public classId!: string;
  public schoolId!: string;
  public date!: Date;
  public sessionType!: "regular" | "weekend" | "holiday" | "extra";

  public readonly createdAt!: Date;
  public readonly updatedAt!: Date;
}

export const initAttendanceModel = (sequelize: Sequelize) => {
  AttendanceModel.init(
    {
      id: {
        type: DataTypes.UUID,
        defaultValue: DataTypes.UUIDV4,
        primaryKey: true,
      },
      classId: {
        type: DataTypes.UUID,
        allowNull: false,
        field: "class_id",
      },
      schoolId: {
        type: DataTypes.UUID,
        allowNull: false,
        field: "school_id",
      },
      date: {
        type: DataTypes.DATEONLY,
        allowNull: false,
        defaultValue: DataTypes.NOW,
      },
      sessionType: {
        type: DataTypes.ENUM("regular", "weekend", "holiday", "extra"),
        allowNull: false,
        defaultValue: "regular",
        field: "session_type",
      },
    },
    {
      sequelize,
      tableName: "attendances",
      timestamps: true,
      underscored: true,
      indexes: [
        {
          unique: true,
          fields: ["class_id", "date", "session_type"],
        },
      ],
    }
  );
};
