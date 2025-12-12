import { Sequelize } from "sequelize";
import { initAttendanceModel, AttendanceModel } from "./models/AttendanceModel";
import {
  initAttendanceRecordModel,
  AttendanceRecordModel,
} from "./models/AttendanceRecordModel";
import { initTuitionModel, TuitionModel } from "./models/TuitionModel";
import { initPaymentModel, PaymentModel } from "./models/PaymentModel";
import { initHolidayModel, HolidayModel } from "./models/HolidayModel";

const sequelize = new Sequelize(
  process.env.PG_DATABASE || "omnimeredu_payment_db",
  process.env.PG_USER || "postgres",
  process.env.PG_PASSWORD || "postgres",
  {
    host: process.env.PG_HOST || "localhost",
    port: parseInt(process.env.PG_PORT || "5432"),
    dialect: "postgres",
    logging: process.env.NODE_ENV === "development" ? console.log : false,
    pool: {
      max: 10,
      min: 0,
      acquire: 30000,
      idle: 10000,
    },
  }
);

// Initialize all models
initAttendanceModel(sequelize);
initAttendanceRecordModel(sequelize);
initTuitionModel(sequelize);
initPaymentModel(sequelize);
initHolidayModel(sequelize);

// Define associations
AttendanceModel.hasMany(AttendanceRecordModel, {
  foreignKey: "attendanceId",
  as: "records",
});
AttendanceRecordModel.belongsTo(AttendanceModel, {
  foreignKey: "attendanceId",
  as: "attendance",
});

TuitionModel.hasMany(PaymentModel, {
  foreignKey: "tuitionId",
  as: "payments",
});
PaymentModel.belongsTo(TuitionModel, {
  foreignKey: "tuitionId",
  as: "tuition",
});

export const connectDatabase = async () => {
  try {
    await sequelize.authenticate();
    console.log("✅ PostgreSQL connection established successfully.");

    if (process.env.NODE_ENV === "development") {
      await sequelize.sync({ alter: true });
      console.log("✅ Database synchronized.");
    }
  } catch (error) {
    console.error("❌ Unable to connect to PostgreSQL:", error);
    throw error;
  }
};

export { sequelize };
export {
  AttendanceModel,
  AttendanceRecordModel,
  TuitionModel,
  PaymentModel,
  HolidayModel,
};
