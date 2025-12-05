import express from "express";
import cors from "cors";
import dotenv from "dotenv";
import morgan from "morgan";

// import { connectMongoDB } from "./common/configs/mongoDBConfig";

// import route from "./common/api/routes/site.route";
// import errorHandler from "./common/api/middlewares/errorHandler.middleware";

dotenv.config();

const app = express();

// Middleware cơ bản
app.use(cors());
app.use(express.json());

// Ghi log theo format 'dev' (dành cho môi trường dev)
app.use(morgan("dev"));

// Khi production thì  sẽ thêm một middleware giới hạn request tránh sập

import userRoutes from "./presentation/routes/user.routes";
import schoolRoutes from "./presentation/routes/school.routes";

// Mount routes
app.use("/api/users", userRoutes);
app.use("/api/schools", schoolRoutes);

// app.use(errorHandler);

// Kết nối DB + Firebase
// connectMongoDB();

export default app;
