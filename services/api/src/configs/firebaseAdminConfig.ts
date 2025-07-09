import admin from "firebase-admin";
import path from "path";

/**
 * Khởi tạo Firebase Admin SDK cho backend.
 * Lưu ý: Đảm bảo file serviceAccountKey.json KHÔNG đưa lên Git.
 */
export const initializeFirebaseAdmin = (): void => {
  try {
    // Tạo đường dẫn tuyệt đối để tránh lỗi relative path khi chạy ở nhiều môi trường
    const serviceAccountPath = path.resolve(
      __dirname,
      "../../serviceAccountKey.json"
    );

    // Import file JSON
    // eslint-disable-next-line @typescript-eslint/no-var-requires
    const serviceAccount = require(serviceAccountPath);

    admin.initializeApp({
      credential: admin.credential.cert(serviceAccount),
    });

    console.log("✅ Firebase Admin SDK đã được khởi tạo.");
  } catch (error: any) {
    console.error("❌ Lỗi khi khởi tạo Firebase Admin SDK:", error.message);
    process.exit(1); // Thoát nếu không khởi tạo được
  }
};
