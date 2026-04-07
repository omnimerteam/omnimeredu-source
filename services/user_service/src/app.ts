import express from "express";
import cors from "cors";
import dotenv from "dotenv";
import morgan from "morgan";
import routes from "./presentation/routes";
import { errorHandler, notFoundHandler, requestLogger, auditTrail } from "./presentation/middleware";

dotenv.config();

const app = express();

// Middleware cơ bản
app.use(cors());
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true, limit: '10mb' }));

// Apply rate limiting to all requests

// Logging middleware
app.use(morgan("combined")); // More detailed logging for production
app.use(requestLogger);

// Mount routes
app.use("/api", auditTrail, routes);

// 404 handler
app.use(notFoundHandler);

// Global error handler (must be last)
app.use(errorHandler);

export default app;
