import { Schema } from "mongoose";
import { IBaseUser } from "./BaseUser";
import BaseUser from "./BaseUser";

/**
 * Interface đại diện cho SuperAdmin (quản trị cấp cao),
 * kế thừa toàn bộ thuộc tính từ IBaseUser
 */
export interface ISuperAdmin extends IBaseUser {
  // Có thể bổ sung thêm thuộc tính riêng trong tương lai
}

/**
 * Schema cho SuperAdmin
 * Hiện tại không có thuộc tính riêng ngoài BaseUser
 */
const SuperAdminSchema = new Schema<ISuperAdmin>({});

/**
 * Tạo discriminator SuperAdmin dựa trên BaseUser
 */
const SuperAdmin = BaseUser.discriminator<ISuperAdmin>(
  "SuperAdmin",
  SuperAdminSchema
);

export default SuperAdmin;
