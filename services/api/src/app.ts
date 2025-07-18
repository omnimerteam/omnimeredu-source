import express from "express";
import cors from "cors";
import dotenv from "dotenv";

import { connectMongoDB } from "./configs/mongoDBConfig";
import { initializeFirebaseAdmin } from "./configs/firebaseAdminConfig";

import route from "./routes/site.route";

dotenv.config();

const app = express();

// Middleware cơ bản
app.use(cors());
app.use(express.json());

// Mount routes
//Sẽ sử dụng site.route để quản lý tất cả các route của ứng dụng
route(app);

// Kết nối DB + Firebase
connectMongoDB();
initializeFirebaseAdmin();

export default app;
