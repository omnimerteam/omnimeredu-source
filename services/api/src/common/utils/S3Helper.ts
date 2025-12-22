import {
  S3Client,
  PutObjectCommand,
  DeleteObjectCommand,
} from "@aws-sdk/client-s3";
import { v4 as uuidv4 } from "uuid";

// S3 Configuration from environment variables
const AWS_REGION = process.env.AWS_REGION || "ap-southeast-1";
const AWS_S3_BUCKET = process.env.AWS_S3_BUCKET || "";
const AWS_ACCESS_KEY_ID = process.env.AWS_ACCESS_KEY_ID || "";
const AWS_SECRET_ACCESS_KEY = process.env.AWS_SECRET_ACCESS_KEY || "";

// Create S3 Client
const s3Client = new S3Client({
  region: AWS_REGION,
  credentials: {
    accessKeyId: AWS_ACCESS_KEY_ID,
    secretAccessKey: AWS_SECRET_ACCESS_KEY,
  },
});

/**
 * Upload file lên AWS S3
 * @param file - Buffer của file
 * @param fileName - Tên file gốc
 * @param mimeType - MIME type của file
 * @param folder - Folder trên S3 (default: "uploads")
 * @returns URL public của file trên S3
 */
export const uploadToS3 = async (
  file: Buffer,
  fileName: string,
  mimeType: string,
  folder: string = "uploads"
): Promise<{ url: string; key: string }> => {
  if (!AWS_S3_BUCKET) {
    throw new Error("AWS_S3_BUCKET chưa được cấu hình");
  }

  // Generate unique file name
  const uniqueId = uuidv4();
  const extension = fileName.split(".").pop() || "jpg";
  const key = `${folder}/${uniqueId}.${extension}`;

  const command = new PutObjectCommand({
    Bucket: AWS_S3_BUCKET,
    Key: key,
    Body: file,
    ContentType: mimeType,
    ACL: "public-read", // Cho phép public access
  });

  await s3Client.send(command);

  // Generate public URL
  const url = `https://${AWS_S3_BUCKET}.s3.${AWS_REGION}.amazonaws.com/${key}`;

  return { url, key };
};

/**
 * Xóa file từ AWS S3
 * @param key - Key của file trên S3
 */
export const deleteFromS3 = async (key: string): Promise<void> => {
  if (!AWS_S3_BUCKET) {
    throw new Error("AWS_S3_BUCKET chưa được cấu hình");
  }

  const command = new DeleteObjectCommand({
    Bucket: AWS_S3_BUCKET,
    Key: key,
  });

  await s3Client.send(command);
};

/**
 * Upload avatar lên S3
 * Wrapper function cho avatar uploads
 */
export const uploadAvatarToS3 = async (
  file: Buffer,
  fileName: string,
  mimeType: string
): Promise<{ url: string; key: string }> => {
  return uploadToS3(file, fileName, mimeType, "avatars");
};
