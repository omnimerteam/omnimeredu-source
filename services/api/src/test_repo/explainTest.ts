import mongoose from "mongoose";
import { BaseUser } from "../models/BaseUser"; // chỉnh path nếu cần
import dotenv from "dotenv";

dotenv.config();

const run = async () => {
  try {
    await mongoose.connect(process.env.MONGO_URI || "", {
      dbName: process.env.DB_NAME || "omnimeredu2025",
    });
    console.log("✅ Connected to MongoDB");

    const roleIdToCheck = "686f95a2e588b615f7aca67f"; // 👈 thay bằng _id của role cần test

    const result = await BaseUser.find({ roleId: roleIdToCheck })
      .limit(1)
      .explain("executionStats");

    console.dir(result, { depth: null });

    await mongoose.disconnect();
    console.log("✅ Disconnected");
  } catch (error) {
    console.error("❌ Error:", error);
  }
};

run();
