import { Response } from "express";

/**
 * Gửi response thành công (status 200, 201...)
 * @param res - Đối tượng Response từ Express
 * @param data - Dữ liệu muốn trả về (object | array)
 * @param message - Thông điệp mô tả kết quả
 * @param statusCode - HTTP status code (default 200)
 */
export const sendSuccess = (
  res: Response,
  data: any = null,
  message: string = "Thành công",
  statusCode: number = 200
) => {
  return res.status(statusCode).json({
    success: true,
    message,
    data,
  });
};

/**
 * Gửi response thành công khi tạo dữ liệu (status 201)
 * @param res - Đối tượng Response
 * @param data - Dữ liệu mới tạo
 * @param message - Thông điệp tùy chọn (default: "Tạo thành công")
 */
export const sendCreated = (
  res: Response,
  data: any = null,
  message: string = "Tạo thành công"
) => {
  return sendSuccess(res, data, message, 201);
};

/**
 * Gửi response thất bại chuẩn hóa
 * @param res - Đối tượng Response
 * @param message - Thông điệp lỗi
 * @param statusCode - HTTP status code (default 500)
 * @param errorData - Optional: Chi tiết lỗi (nội bộ, dev-only)
 */
export const sendError = (
  res: Response,
  message: string = "Lỗi hệ thống",
  statusCode: number = 500,
  errorData?: any
) => {
  return res.status(statusCode).json({
    success: false,
    message,
    error: errorData ?? null,
  });
};

/**
 * Gửi response khi không tìm thấy dữ liệu (404)
 * @param res - Đối tượng Response
 * @param message - Thông báo tùy chỉnh (default: "Không tìm thấy")
 */
export const sendNotFound = (
  res: Response,
  message: string = "Không tìm thấy"
) => {
  return sendError(res, message, 404);
};
