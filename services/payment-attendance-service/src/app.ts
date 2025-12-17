import express, { Express } from "express";
import cors from "cors";
import morgan from "morgan";
import routes from "./presentation/routes";

const app: Express = express();

// Middleware
app.use(cors());
// Morgan logger - log ngắn gọn cho tất cả requests
app.use(morgan(":method :url :status :response-time ms"));
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Routes
app.use("/api", routes);

// Health Check
app.get("/health", (req, res) => {
  res.status(200).json({ status: "ok" });
});

// 404 handler - must be after all routes
app.use((req: express.Request, res: express.Response) => {
  // Log 404 với format rõ ràng
  console.warn(`⚠️  404 Not Found: ${req.method} ${req.originalUrl}`);
  res.status(404).json({
    success: false,
    error: "Not Found",
    message: `Cannot ${req.method} ${req.originalUrl}`,
    path: req.originalUrl,
  });
});

// Error handling middleware
app.use(
  (
    err: any,
    req: express.Request,
    res: express.Response,
    next: express.NextFunction
  ) => {
    console.error(`❌ Error on ${req.method} ${req.originalUrl}:`, err.message);
    if (process.env.NODE_ENV === "development") {
      console.error(err.stack);
    }
    res.status(err.status || 500).json({
      error: err.message || "Something went wrong!",
      ...(process.env.NODE_ENV === "development" && { stack: err.stack }),
    });
  }
);

export default app;
