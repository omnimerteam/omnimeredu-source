import { Sequelize } from "sequelize";

// Placeholder configuration. In a real app, use environment variables.
export const sequelize = new Sequelize(
  "postgres://postgres:password@localhost:5432/auth_service_db",
  {
    dialect: "postgres",
    logging: false,
  }
);
