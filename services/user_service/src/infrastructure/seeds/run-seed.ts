import dotenv from "dotenv";
dotenv.config();

import { sequelize } from "../../data/datasources/postgres/database";
import { RoleRepositoryImpl } from "../../data/repositories/RoleRepositoryImpl";
import { RoleSeeder } from "./RoleSeeder";

async function runSeed() {
  try {
    // 1. Connect DB
    await sequelize.authenticate();
    console.log("✅ PostgreSQL connected successfully");

    // 2. Initialize dependencies
    const roleRepository = new RoleRepositoryImpl();
    const roleSeeder = new RoleSeeder(roleRepository);

    // 3. Run seed
    await roleSeeder.seed();

    process.exit(0);
  } catch (error) {
    console.error("❌ Seeding failed:", error);
    process.exit(1);
  }
}

runSeed();
