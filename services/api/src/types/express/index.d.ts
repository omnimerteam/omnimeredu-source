// types/express/index.d.ts
import "express";
import { IAccount } from "../../models/Account";

declare module "express" {
  export interface Request {
    user?: any; // Tất cả thông tin của User
    accountId?: string; // ID tài khoản DB của bạn
    role?: string; // Vai trò
  }
}
