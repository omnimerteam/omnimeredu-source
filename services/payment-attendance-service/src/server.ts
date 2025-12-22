import dotenv from "dotenv";
import app from "./app";
import {
  connectDatabase,
  sequelize,
} from "./data/datasources/postgres/database";
import { connectMongoDB } from "./data/datasources/mongodb/client";
import { setupSyncHooks } from "./data/datasources/sync-setup";

dotenv.config();

const port = process.env.PORT || 3002;

const startServer = async () => {
  try {
    // Connect to databases
    await connectDatabase();
    await connectMongoDB();

    // await sequelize.sync({ alter: true });
    // console.log("✅ Database models synced successfully");

    // Setup Sync Hooks
    setupSyncHooks();

    // Start server
    app.listen(port, () => {
      console.log(
        `[server]: Payment & Attendance Server is running at http://localhost:${port}`
      );
    });
  } catch (error) {
    console.error("❌ Stats server failed to start:", error);
    process.exit(1);
  }
};

startServer();
