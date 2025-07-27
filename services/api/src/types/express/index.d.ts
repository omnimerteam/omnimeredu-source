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

/**
 * 
user: {
  _id: new ObjectId('687358d941df16e2a42eed17'), (accountId)
  email: 'huynhtri@gmail.com',
  password: 'Tri@1109',
  uid: '9Wb94ETAdsYKTSlZzNvFTskp47H2',
  userId: {
    _id: new ObjectId('687358d941df16e2a42eed15'),
    fullName: 'Tri@1109',
    roleId: { _id: new ObjectId('686f95a2e588b615f7aca67f'), name: 'Student' },
    gender: 'Male',
    phone: '121212',
    isVerified: false,
    createdAt: 2025-07-13T06:57:29.479Z,
    updatedAt: 2025-07-13T06:57:29.479Z,
    __v: 0
  },
  createdAt: 2025-07-13T06:57:29.529Z,
  updatedAt: 2025-07-13T06:57:29.529Z,
  __v: 0
}

 */
