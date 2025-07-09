import mongoose from "mongoose";

/**
 * Kết nối MongoDB sử dụng URI từ biến môi trường.
 * Gọi hàm này khi khởi động server để thiết lập kết nối.
 */
export const connectDB = async (): Promise<void> => {
  try {
    const mongoUri = process.env.MONGO_URI;

    if (!mongoUri) {
      throw new Error("Biến môi trường MONGO_URI chưa được cấu hình.");
    }

    await mongoose.connect(mongoUri);
    console.log("MongoDB đã kết nối thành công!");
  } catch (error: any) {
    console.error("Lỗi kết nối MongoDB:", error.message);
    process.exit(1); // Thoát ứng dụng nếu không kết nối được DB
  }
};
