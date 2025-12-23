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

    // Start server - bind to 0.0.0.0 to allow access from emulator/network
    app.listen(port, "0.0.0.0", () => {
      console.log(
        `[server]: Payment & Attendance Server is running at http://0.0.0.0:${port}`
      );
      console.log(
        `[server]: Accessible from emulator at http://10.0.2.2:${port}`
      );
    });
  } catch (error) {
    console.error("❌ Stats server failed to start:", error);
    process.exit(1);
  }
};

startServer();
