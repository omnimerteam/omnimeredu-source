import { NoSQLClientFactory, NoSQLType } from "shared-lib";
import dotenv from "dotenv";

dotenv.config();

const mongoUri =
  process.env.MONGO_URI || "mongodb://localhost:27017/omnimeredu_read_db";

export const noSQLClient = NoSQLClientFactory.createClient(
  NoSQLType.MONGODB,
  mongoUri
);

export const connectNoSQL = async () => {
  await noSQLClient.connect();
};
