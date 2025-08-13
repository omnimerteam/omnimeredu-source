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
          "user": {
            "_id": "6889e705cf2912e821efd171", // Cái này là id của user
            "fullName": "Tri",
            "roleId": {
                "_id": "686f95a2e588b615f7aca67e", // ID của Role
                "name": "Teacher"
            },
            "gender": "Male",
            "phone": "454353453",
            "isVerified": false,
            "roleKey": "Teacher",
            "literacy": "Đại học Sư phạm TP.HCM",
            "subjects": [
                "Toán",
                "Lý"
            ],
            "schoolId": "6878ae00072ff5aee0099cc2",
            "createdAt": "2025-07-30T09:33:57.311Z",
            "updatedAt": "2025-07-30T09:33:57.311Z",
            "__v": 0
        }

 */
