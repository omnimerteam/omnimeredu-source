import { Sequelize } from "sequelize";

export const connectPostgres = (uri: string) => {
  const sequelize = new Sequelize(uri, {
    dialect: "postgres",
    logging: false,
  });
  return sequelize;
};
