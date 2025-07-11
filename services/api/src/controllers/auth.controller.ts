import { Request, Response } from "express";
import * as AuthService from "../services/auth.services";
import Role from "../models/Role";

export const register = async (req: Request, res: Response) => {
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
    res.json({ message: "Register success", user });
  } catch (error: any) {
    res.status(500).json({ message: "Error", error: error.message });
  }
};

export const getUserByUid = async (req: Request, res: Response) => {
  try {
    const uid = req.params.uid;
    console.log("uid", uid);
    const account = await AuthService.getUserByUid(uid);
    res.status(200).json({
      userId: account.userId,
      role: "account.role,",
    });
  } catch (error: any) {
    res.status(404).json({ message: "Not found", error: error.message });
  }
};
