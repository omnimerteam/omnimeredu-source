// 1. Thêm Op vào phần import
import { DataTypes, Model, Sequelize, Op } from "sequelize";

export class TuitionModel extends Model {
  public id!: string;
  public studentId!: string;
  public schoolId!: string;
  public classId!: string;
  public month?: string;
  public periodStart?: Date;
  public periodEnd?: Date;
  public baseFeeSnapshot!: number;
  public extraFeeDetails?: any[];
  public discountDetails?: any[];
  public appliedRules?: any[];
  public calculationLog?: Record<string, any>;
  public totalAmount!: number;
  public attendedDays!: number;
  public currency!: "VND" | "USD";
  public status!: "Draft" | "Pending" | "Paid" | "Cancelled" | "Failed";
  public createdBy?: string;
  public confirmedBy?: string;
  public confirmedAt?: Date;
  public paidAt?: Date;
  public invoiceId?: string;
  public dueDate?: Date;
  public meta?: Record<string, any>;

  public readonly createdAt!: Date;
  public readonly updatedAt!: Date;
}

export const initTuitionModel = (sequelize: Sequelize) => {
  TuitionModel.init(
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
      schoolId: {
        type: DataTypes.UUID,
        allowNull: false,
        field: "school_id",
      },
      classId: {
        type: DataTypes.UUID,
        allowNull: false,
        field: "class_id",
      },
      month: {
        type: DataTypes.STRING,
        allowNull: true,
      },
      periodStart: {
        type: DataTypes.DATE,
        allowNull: true,
        field: "period_start",
      },
      periodEnd: {
        type: DataTypes.DATE,
        allowNull: true,
        field: "period_end",
      },
      baseFeeSnapshot: {
        type: DataTypes.DECIMAL(15, 2),
        allowNull: false,
        field: "base_fee_snapshot",
      },
      extraFeeDetails: {
        type: DataTypes.JSONB,
        allowNull: true,
        defaultValue: [],
        field: "extra_fee_details",
      },
      discountDetails: {
        type: DataTypes.JSONB,
        allowNull: true,
        defaultValue: [],
        field: "discount_details",
      },
      appliedRules: {
        type: DataTypes.JSONB,
        allowNull: true,
        field: "applied_rules",
      },
      calculationLog: {
        type: DataTypes.JSONB,
        allowNull: true,
        field: "calculation_log",
      },
      totalAmount: {
        type: DataTypes.DECIMAL(15, 2),
        allowNull: false,
        field: "total_amount",
      },
      attendedDays: {
        type: DataTypes.INTEGER,
        defaultValue: 0,
        field: "attended_days",
      },
      currency: {
        type: DataTypes.ENUM("VND", "USD"),
        defaultValue: "VND",
      },
      status: {
        type: DataTypes.ENUM("Draft", "Pending", "Paid", "Cancelled", "Failed"),
        defaultValue: "Draft",
      },
      createdBy: {
        type: DataTypes.UUID,
        allowNull: true,
        field: "created_by",
      },
      confirmedBy: {
        type: DataTypes.UUID,
        allowNull: true,
        field: "confirmed_by",
      },
      confirmedAt: {
        type: DataTypes.DATE,
        allowNull: true,
        field: "confirmed_at",
      },
      paidAt: {
        type: DataTypes.DATE,
        allowNull: true,
        field: "paid_at",
      },
      invoiceId: {
        type: DataTypes.STRING,
        allowNull: true,
        field: "invoice_id",
      },
      dueDate: {
        type: DataTypes.DATE,
        allowNull: true,
        field: "due_date",
      },
      meta: {
        type: DataTypes.JSONB,
        allowNull: true,
        defaultValue: {},
      },
    },
    {
      sequelize,
      tableName: "tuitions",
      timestamps: true,
      underscored: true,
      indexes: [
        {
          unique: true,
          fields: ["student_id", "school_id", "period_start"],
          where: {
            period_start: {
              // 2. Sửa đoạn này: Dùng trực tiếp Op.ne
              [Op.ne]: null,
            },
          },
        },
        {
          fields: ["status"],
        },
        {
          fields: ["school_id", "period_start"],
        },
      ],
    }
  );
};