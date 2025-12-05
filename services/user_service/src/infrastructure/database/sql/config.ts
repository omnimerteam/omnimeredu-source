import { connectPostgres } from "shared-lib";
import dotenv from "dotenv";

dotenv.config();

const dbName = process.env.DB_NAME || "auth_service_db";
const dbUser = process.env.DB_USER || "postgres";
const dbPass = process.env.DB_PASS || "password";
const dbHost = process.env.DB_HOST || "localhost";
const dbPort = process.env.DB_PORT || "5432";

const uri = `postgres://${dbUser}:${dbPass}@${dbHost}:${dbPort}/${dbName}`;

export const sequelize = connectPostgres(uri);
