import dotenv from "dotenv";
dotenv.config();

import app from "./app";

import { sequelize } from "./data/datasources/postgres/database";
import { noSQLClient } from "./data/datasources/mongodb/client";
import { initMongoDBModels } from "./data/datasources/mongodb/init";
import { setupSyncHooks } from "./data/datasources/sync-setup";

const PORT: number = parseInt(process.env.PORT || "5000", 10);

app.listen(PORT, "0.0.0.0", async () => {
  try {
    // Connect to PostgreSQL
    await sequelize.authenticate();
    console.log("✅ PostgreSQL connected successfully");

    // Sync database models
    // await sequelize.sync({ alter: true });
    // console.log("✅ Database models synced successfully");

    // Connect to MongoDB
    await noSQLClient.connect();
    initMongoDBModels();

    // Setup Sync Hooks
    setupSyncHooks();
    console.log("✅ Sync Hooks setup successfully");
  } catch (error) {
    console.error("❌ Database connection failed:", error);
  }

  console.log(
    `🚀 Server is running on http://localhost:${PORT} in ${process.env.NODE_ENV} mode`
  );
});
