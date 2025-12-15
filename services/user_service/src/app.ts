import express from "express";
import cors from "cors";
import dotenv from "dotenv";
import morgan from "morgan";
import routes from "./presentation/routes";

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

// Mount routes
app.use("/api", routes);

// app.use(errorHandler);

// Kết nối DB + Firebase
// connectMongoDB();

export default app;
