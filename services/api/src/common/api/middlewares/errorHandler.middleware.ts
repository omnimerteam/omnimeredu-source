import { Request, Response, NextFunction } from "express";
import chalk from "chalk";
import { cleanErrorMessage, sendError } from "../../utils/ResponseHelper";
import dotenv from "dotenv";

dotenv.config();

export interface CustomError extends Error {
  status?: number;
  code?: string;
  errorData?: any; // Dùng để đính kèm thông tin kỹ thuật chi tiết
}

/**
 * Middleware xử lý lỗi toàn cục.
 * Bất kỳ lỗi nào được throw hoặc truyền vào next(err) từ controller/service
 * đều sẽ được gom về đây để xử lý & phản hồi theo chuẩn JSON chung.
 *
 * @param err - Lỗi được truyền vào
 * @param req - Request từ client
 * @param res - Response trả về
 * @param next - Middleware tiếp theo (không dùng)
 */
const errorHandler = (
  err: CustomError,
  req: Request,
  res: Response,
  next: NextFunction
): void => {
  const status = err.status || 500;
  const message = err.message || "Lỗi hệ thống";

  console.log(
    chalk.red(`[ERROR] ❌ ${req.method} ${req.originalUrl}`),
    chalk.gray(`→ Status: ${status}`),
    err.stack || err
  );

  sendError(
    res,
    cleanErrorMessage(message),
    status,
    process.env.NODE_ENV === "development" ? err.stack : undefined
  );
};

export default errorHandler;
