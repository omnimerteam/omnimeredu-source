import express, { NextFunction, Request, Response } from "express";
import multer from "multer";
import admin from "firebase-admin";
import { v4 as uuidv4 } from "uuid";
import { sendBadRequest, sendSuccess } from "../../utils/ResponseHelper";

const upload = multer({ storage: multer.memoryStorage() });
const router = express.Router();

/**
 * POST /api/upload/avatar-temp
 * Upload ảnh tạm thời (chưa có UID)
 * Body: form-data { file: <image> }
 */
router.post(
  "/avatar-temp",
  upload.single("file"),
  async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const bucket = admin.storage().bucket();
      const file = req.file;
      if (!file) {
        sendBadRequest(res, "Thiếu file ảnh upload");
        return;
      }

      const randomId = uuidv4();
      const filePath = `avatar_temp/${randomId}_${file.originalname}`;
      const blob = bucket.file(filePath);

      await blob.save(file.buffer, {
        metadata: { contentType: file.mimetype },
      });

      // Tạo URL ký sẵn (read-only)
      const [url] = await blob.getSignedUrl({
        action: "read",
        expires: "03-09-2500",
      });

      sendSuccess(res, { url, filePath }, "Upload ảnh tạm thành công");
      return;
    } catch (error) {
      console.error("❌ Upload avatar_temp failed:", error);
      return next(error);
    }
  }
);

export default router;
