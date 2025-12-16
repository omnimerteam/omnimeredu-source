import { DataTypes, Model, Sequelize } from "shared-lib";

export class AttendanceRecordModel extends Model {
  public id!: string;
  public studentId!: string;
  public attendanceId!: string;
  public status!:
    | "Present"
    | "AbsentWithLeave"
    | "Absent"
    | "Late"
    | "LeftEarly";
  public note?: string;

  public readonly createdAt!: Date;
  public readonly updatedAt!: Date;
}

export const initAttendanceRecordModel = (sequelize: Sequelize) => {
  AttendanceRecordModel.init(
    {
      id: {
        type: DataTypes.UUID,
        defaultValue: DataTypes.UUIDV4,
        primaryKey: true,
      },
      studentId: {
        type: DataTypes.UUID,
        allowNull: false,
        field: "student_id",
      },
      attendanceId: {
        type: DataTypes.UUID,
        allowNull: false,
        field: "attendance_id",
        references: {
          model: "attendances",
          key: "id",
        },
        onDelete: "CASCADE",
      },
      status: {
        type: DataTypes.ENUM(
          "Present",
          "AbsentWithLeave",
          "Absent",
          "Late",
          "LeftEarly"
        ),
        allowNull: false,
        defaultValue: "Present",
      },
      note: {
        type: DataTypes.TEXT,
        allowNull: true,
      },
    },
    {
      sequelize,
      tableName: "attendance_records",
      timestamps: true,
      underscored: true,
      indexes: [
        {
          fields: ["attendance_id"],
        },
        {
          fields: ["student_id"],
        },
      ],
    }
  );
};
