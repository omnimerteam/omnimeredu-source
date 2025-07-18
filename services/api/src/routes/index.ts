import { Router, Request, Response } from "express";

const router = Router();

/**
 * Root route để test server đang hoạt động.
 * Truy cập: GET /
 */
router.get("/", (req: Request, res: Response) => {
  res.json({
    status: "success",
    message: "🎉 OmniMerEDU API is running!",
    version: "1.0.0",
    timestamp: new Date().toISOString(),
  });
});

export default router;
