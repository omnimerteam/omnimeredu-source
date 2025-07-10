import express from "express";
import cors from "cors";
import dotenv from "dotenv";

import { connectMongoDB } from "./configs/mongoDBConfig";
import { initializeFirebaseAdmin } from "./configs/firebaseAdminConfig";

import indexRoutes from "./routes/index";
import authRoutes from "./routes/auth.route";

dotenv.config();

const app = express();

// Middleware cơ bản
app.use(cors());
app.use(express.json());

// Mount routes
app.use("/", indexRoutes); // Root: /
app.use("/api/user", authRoutes); // API Auth: /api/users/...

// Kết nối DB + Firebase
connectMongoDB();
initializeFirebaseAdmin();

export default app;
