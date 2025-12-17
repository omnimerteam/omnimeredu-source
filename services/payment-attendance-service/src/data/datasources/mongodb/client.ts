import mongoose from "mongoose";

const MONGODB_URI =
  process.env.MONGO_URI || "";

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
