import { DataTypes, Model, Sequelize } from "sequelize";

export class HolidayModel extends Model {
  public id!: string;
  public schoolId?: string;
  public name!: string;
  public date!: Date;
  public isRecurring!: boolean;
  public type!: "national" | "school";

  public readonly createdAt!: Date;
  public readonly updatedAt!: Date;
}

export const initHolidayModel = (sequelize: Sequelize) => {
  HolidayModel.init(
    {
      id: {
        type: DataTypes.UUID,
        defaultValue: DataTypes.UUIDV4,
        primaryKey: true,
      },
      schoolId: {
        type: DataTypes.UUID,
        allowNull: true,
        field: "school_id",
      },
      name: {
        type: DataTypes.STRING,
        allowNull: false,
      },
      date: {
        type: DataTypes.DATEONLY,
        allowNull: false,
      },
      isRecurring: {
        type: DataTypes.BOOLEAN,
        defaultValue: false,
        field: "is_recurring",
      },
      type: {
        type: DataTypes.ENUM("national", "school"),
        defaultValue: "national",
      },
    },
    {
      sequelize,
      tableName: "holidays",
      timestamps: true,
      underscored: true,
      indexes: [
        {
          fields: ["date", "school_id"],
        },
        {
          fields: ["type"],
        },
      ],
    }
  );
};
