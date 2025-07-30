import { NextFunction, Request, Response } from "express";
import * as AuthService from "../services/auth.services";
import {
  sendCreated,
  sendNotFound,
  sendSuccess,
} from "../utils/ResponseHelper";

/**
 * Đăng ký người dùng mới
 */
export const register = async (
  req: Request,
  res: Response,
  next: NextFunction
): Promise<void> => {
  try {
    const {
      uid,
      email,
      password,
      roleId,
      fullName,
      gender,
      phone,
      schoolId,
      classId,
      literacy,
      subjects,
    } = req.body;

    // Gom tất cả field vào userInfo (dùng cho BaseUser hoặc subclass)
    const userInfo = {
      fullName,
      gender,
      phone,
      schoolId,
      classId,
      literacy,
      subjects,
    };

    const user = await AuthService.registerUser(
      uid,
      email,
      password,
      roleId,
      userInfo
    );

    sendCreated(res, user, "Đăng ký thành công");
    return;
  } catch (error: any) {
    console.error("❌ register error:", error.message);
    return next(error);
  }
};

/**
 * Lấy role hiện tại của user đã verify
 * -> Role đã được gán ở middleware verifyRole()
 */
export const login = async (
  req: Request,
  res: Response,
  next: NextFunction
): Promise<void> => {
  try {
    const user = req.user;

    if (!user) {
      sendNotFound(res, "Không tìm thấy thông tin người dùng");
      return;
    }

    sendSuccess(res, { user: user });
    return;
  } catch (error: any) {
    console.error("❌ getUserRole error:", error.message);
    return next(error);
  }
};
