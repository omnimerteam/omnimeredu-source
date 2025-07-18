import express from "express";
import cors from "cors";
import dotenv from "dotenv";
import morgan from "morgan";

import { connectMongoDB } from "./configs/mongoDBConfig";
import { initializeFirebaseAdmin } from "./configs/firebaseAdminConfig";

import route from "./routes/site.route";

dotenv.config();

const app = express();

// Middleware cơ bản
app.use(cors());
app.use(express.json());

// Ghi log theo format 'dev' (dành cho môi trường dev)
app.use(morgan("dev"));

// Mount routes
//Sẽ sử dụng site.route để quản lý tất cả các route của ứng dụng
route(app);

// Kết nối DB + Firebase
connectMongoDB();
initializeFirebaseAdmin();

export default app;
