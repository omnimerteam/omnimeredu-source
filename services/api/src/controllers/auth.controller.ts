import { Request, Response } from "express";
import * as AuthService from "../services/auth.services";

/**
 * Đăng ký người dùng mới
 */
export const register = async (req: Request, res: Response): Promise<void> => {
  try {
    const { uid, email, fullName, gender, phone, role, password } = req.body;

    const user = await AuthService.registerUser(
      uid,
      email,
      fullName,
      gender,
      phone,
      role,
      password
    );

    res.status(200).json({ message: "Register success", user });
    return;
  } catch (error: any) {
    console.error("❌ register error:", error.message);
    res.status(500).json({ message: "Error", error: error.message });
    return;
  }
};

/**
 * Lấy role hiện tại của user đã verify
 * -> Role đã được gán ở middleware verifyRole()
 */
export const getUserRole = async (
  req: Request,
  res: Response
): Promise<void> => {
  try {
    const roleUser = (req as any).role;

    if (!roleUser) {
      res.status(404).json({ message: "No role assigned" });
      return;
    }

    res.status(200).json({ role: roleUser });
    return;
  } catch (error: any) {
    console.error("❌ getUserRole error:", error.message);
    res.status(500).json({ message: "Internal server error" });
    return;
  }
};
