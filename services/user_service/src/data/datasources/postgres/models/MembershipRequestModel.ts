import { DataTypes, Model, Sequelize } from "shared-lib";
import {
  MembershipRoleEnum,
  MembershipActionEnum,
  MembershipStatusEnum,
} from "shared-lib";

export class MembershipRequestModel extends Model {
  public id!: string;
  public userId!: string;
  public schoolId!: string;
  public classId?: string;
  public role!: MembershipRoleEnum;
  public action!: MembershipActionEnum;
  public status!: MembershipStatusEnum;
  public note?: string;

  public readonly createdAt!: Date;
  public readonly updatedAt!: Date;
}

export const initMembershipRequestModel = (sequelize: Sequelize) => {
  MembershipRequestModel.init(
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
          model: "users",
          key: "id",
        },
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
      classId: {
        type: DataTypes.UUID,
        allowNull: true,
        field: "class_id",
        references: {
          model: "classes",
          key: "id",
        },
      },
      role: {
        type: DataTypes.ENUM(...Object.values(MembershipRoleEnum)),
        allowNull: false,
      },
      action: {
        type: DataTypes.ENUM(...Object.values(MembershipActionEnum)),
        allowNull: false,
      },
      status: {
        type: DataTypes.ENUM(...Object.values(MembershipStatusEnum)),
        defaultValue: MembershipStatusEnum.Pending,
      },
      note: {
        type: DataTypes.TEXT,
        allowNull: true,
      },
    },
    {
      sequelize,
      tableName: "membership_requests",
      timestamps: true,
      underscored: true,
    }
  );
};
