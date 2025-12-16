import express from "express";
import cors from "cors";
import dotenv from "dotenv";
import morgan from "morgan";
import rateLimit from "express-rate-limit";
import routes from "./presentation/routes";
import { errorHandler, notFoundHandler, requestLogger, auditTrail } from "./presentation/middleware";

dotenv.config();

const app = express();

// Rate limiting middleware
const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 1000, // limit each IP to 1000 requests per windowMs
  message: {
    success: false,
    message: 'Too many requests from this IP, please try again later'
  }
});

// Middleware cơ bản
app.use(cors());
app.use(express.json({ limit: '10mb' }));
app.use(express.urlencoded({ extended: true, limit: '10mb' }));

// Apply rate limiting to all requests
if (process.env.NODE_ENV === 'production') {
  app.use(limiter);
}

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
