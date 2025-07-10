import { Request, Response } from "express";
import * as AuthService from "../services/auth.services";

export const register = async (req: Request, res: Response) => {
  try {
    const { uid, email, fullName, gender, phone, role } = req.body;
    const user = await AuthService.registerUser(
      uid,
      email,
      fullName,
      gender,
      phone,
      role
    );
    res.json({ message: "Register success", user });
  } catch (error: any) {
    res.status(500).json({ message: "Error", error: error.message });
  }
};

export const getUserByUid = async (req: Request, res: Response) => {
  try {
    const uid = req.params.uid;
    const account = await AuthService.getUserByUid(uid);
    res.json({
      profile: account.userId,
    });
  } catch (error: any) {
    res.status(404).json({ message: "Not found", error: error.message });
  }
};
