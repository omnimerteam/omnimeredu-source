import { Sequelize, Options } from "sequelize";

export const connectPostgres = (
  uri: string,
  additionalOptions: Options = {}
) => {
  const isLocal = uri.includes("localhost") || uri.includes("127.0.0.1");

  const defaultOptions: Options = {
    dialect: "postgres",
    logging: false,
    dialectOptions: isLocal
      ? {}
      : {
          ssl: {
            require: true,
            rejectUnauthorized: false,
          },
        },
  };

  const sequelize = new Sequelize(uri, {
    ...defaultOptions,
    ...additionalOptions,
  });
  return sequelize;
};
