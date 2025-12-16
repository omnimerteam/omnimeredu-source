import { DataTypes, Model, Sequelize } from "shared-lib";

export class PaymentModel extends Model {
  public id!: string;
  public studentId!: string;
  public tuitionId!: string;
  public paymentMethodId!: string;
  public amount!: number;
  public transactionId!: string;
  public status!: "Success" | "Failed";
  public paidAt!: Date;

  public readonly createdAt!: Date;
  public readonly updatedAt!: Date;
}

export const initPaymentModel = (sequelize: Sequelize) => {
  PaymentModel.init(
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
      tuitionId: {
        type: DataTypes.UUID,
        allowNull: false,
        field: "tuition_id",
        references: {
          model: "tuitions",
          key: "id",
        },
      },
      paymentMethodId: {
        type: DataTypes.UUID,
        allowNull: false,
        field: "payment_method_id",
      },
      amount: {
        type: DataTypes.DECIMAL(15, 2),
        allowNull: false,
      },
      transactionId: {
        type: DataTypes.STRING,
        allowNull: false,
        unique: true,
        field: "transaction_id",
      },
      status: {
        type: DataTypes.ENUM("Success", "Failed"),
        allowNull: false,
      },
      paidAt: {
        type: DataTypes.DATE,
        allowNull: false,
        field: "paid_at",
      },
    },
    {
      sequelize,
      tableName: "payments",
      timestamps: true,
      underscored: true,
      indexes: [
        {
          fields: ["tuition_id"],
        },
        {
          fields: ["student_id"],
        },
        {
          unique: true,
          fields: ["transaction_id"],
        },
      ],
    }
  );
};
