import { NoSQLClientFactory, NoSQLType } from "shared-lib";
import dotenv from "dotenv";

dotenv.config();

const mongoUri =
  process.env.MONGO_URI || "";

export const noSQLClient = NoSQLClientFactory.createClient(
  NoSQLType.MONGODB,
  mongoUri
);
