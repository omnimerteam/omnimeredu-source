import {
  S3Client,
  PutObjectCommand,
  DeleteObjectCommand,
} from "@aws-sdk/client-s3";
import { v4 as uuidv4 } from "uuid";

// AWS S3 Configuration
const AWS_REGION = process.env.AWS_REGION || "us-east-1";
const AWS_S3_BUCKET = process.env.AWS_S3_BUCKET || "omnimeredu-avatars";
const AWS_ACCESS_KEY_ID = process.env.AWS_ACCESS_KEY_ID || "";
const AWS_SECRET_ACCESS_KEY = process.env.AWS_SECRET_ACCESS_KEY || "";

// Initialize S3 Client
const s3Client = new S3Client({
  region: AWS_REGION,
  credentials: {
    accessKeyId: AWS_ACCESS_KEY_ID,
    secretAccessKey: AWS_SECRET_ACCESS_KEY,
  },
});

export class S3Utils {
  /**
   * Upload user avatar to Amazon S3
   * @param userId - User ID
   * @param fileBuffer - File buffer
   * @param mimetype - File MIME type
   * @returns Object containing file key and URL
   */
  static async uploadAvatar(
    userId: string,
    fileBuffer: Buffer,
    mimetype: string
  ): Promise<{ key: string; url: string }> {
    const fileExtension = mimetype.split("/")[1] || "jpg";
    const fileName = `avatar-${userId}`;
    const key = `avatars/${fileName}.${fileExtension}`;

    const uploadParams = {
      Bucket: AWS_S3_BUCKET,
      Key: key,
      Body: fileBuffer,
      ContentType: mimetype,
      // Make the file publicly readable (optional, adjust based on your security requirements)
      // ACL: 'public-read', // Note: ACL may need specific bucket permissions
    };

    try {
      await s3Client.send(new PutObjectCommand(uploadParams));

      // Construct the URL (adjust based on your S3 configuration)
      const url = `https://${AWS_S3_BUCKET}.s3.${AWS_REGION}.amazonaws.com/${key}`;

      return { key, url };
    } catch (error) {
      console.error("Error uploading to S3:", error);
      throw new Error("Failed to upload avatar to S3");
    }
  }

  /**
   * Delete user avatar from Amazon S3
   * @param userId - User ID
   * @returns True if deletion was successful
   */
  static async deleteAvatar(userId: string): Promise<boolean> {
    // Try common image extensions
    const extensions = ["jpg", "jpeg", "png", "gif", "webp"];

    for (const ext of extensions) {
      const fileName = `avatar-${userId}`;
      const key = `avatars/${fileName}.${ext}`;

      try {
        const deleteParams = {
          Bucket: AWS_S3_BUCKET,
          Key: key,
        };

        await s3Client.send(new DeleteObjectCommand(deleteParams));
        return true;
      } catch (error) {
        // Continue to next extension
        continue;
      }
    }

    return false;
  }

  /**
   * Upload file to S3 with custom path
   * @param filePath - Custom file path in S3
   * @param fileBuffer - File buffer
   * @param mimetype - File MIME type
   * @returns Object containing file key and URL
   */
  static async uploadFile(
    filePath: string,
    fileBuffer: Buffer,
    mimetype: string
  ): Promise<{ key: string; url: string }> {
    const uploadParams = {
      Bucket: AWS_S3_BUCKET,
      Key: filePath,
      Body: fileBuffer,
      ContentType: mimetype,
    };

    try {
      await s3Client.send(new PutObjectCommand(uploadParams));

      const url = `https://${AWS_S3_BUCKET}.s3.${AWS_REGION}.amazonaws.com/${filePath}`;

      return { key: filePath, url };
    } catch (error) {
      console.error("Error uploading to S3:", error);
      throw new Error("Failed to upload file to S3");
    }
  }

  /**
   * Delete file from S3
   * @param key - S3 object key
   * @returns True if deletion was successful
   */
  static async deleteFile(key: string): Promise<boolean> {
    try {
      const deleteParams = {
        Bucket: AWS_S3_BUCKET,
        Key: key,
      };

      await s3Client.send(new DeleteObjectCommand(deleteParams));
      return true;
    } catch (error) {
      console.error("Error deleting from S3:", error);
      return false;
    }
  }
}
