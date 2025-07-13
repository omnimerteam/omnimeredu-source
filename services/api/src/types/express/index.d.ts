// types/express/index.d.ts
import "express";

declare module "express" {
  export interface Request {
    user?: any; // Thông tin Firebase decode
    accountId?: string; // ID tài khoản DB của bạn
    role?: string; // Vai trò
  }
}
