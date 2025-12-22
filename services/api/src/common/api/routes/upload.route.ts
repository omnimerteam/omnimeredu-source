import express, { NextFunction, Request, Response } from "express";
import multer from "multer";
import admin from "firebase-admin";
import { v4 as uuidv4 } from "uuid";
import { sendBadRequest, sendSuccess } from "../../utils/ResponseHelper";
import { uploadAvatarToS3 } from "../../utils/S3Helper";

const upload = multer({ storage: multer.memoryStorage() });
const router = express.Router();

/**
 * POST /api/upload/avatar-temp
 * Upload ảnh tạm thời (chưa có UID) lên Firebase Storage
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

/**
 * POST /api/upload/avatar-s3
 * Upload ảnh lên AWS S3
 * Body: form-data { file: <image> }
 * Returns: { url: string, key: string }
 */
router.post(
  "/avatar-s3",
  upload.single("file"),
  async (req: Request, res: Response, next: NextFunction): Promise<void> => {
    try {
      const file = req.file;
      if (!file) {
        sendBadRequest(res, "Thiếu file ảnh upload");
        return;
      }

      const result = await uploadAvatarToS3(
        file.buffer,
        file.originalname,
        file.mimetype
      );

      sendSuccess(res, result, "Upload ảnh lên S3 thành công");
      return;
    } catch (error) {
      console.error("❌ Upload avatar_s3 failed:", error);
      return next(error);
    }
  }
);

export default router;
