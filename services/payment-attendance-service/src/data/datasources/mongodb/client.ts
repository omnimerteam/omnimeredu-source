import mongoose from "mongoose";

const MONGODB_URI =
  process.env.MONGODB_URI || "mongodb://localhost:27017/omnimeredu_read_db";

export const connectMongoDB = async () => {
  try {
    await mongoose.connect(MONGODB_URI);
    console.log("✅ MongoDB connection established successfully.");
  } catch (error) {
    console.error("❌ Unable to connect to MongoDB:", error);
    throw error;
  }
};

export const noSQLClient = mongoose.connection;
