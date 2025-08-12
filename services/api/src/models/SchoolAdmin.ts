import { Schema } from "mongoose";
import { IBaseUser } from "./BaseUser";
import BaseUser from "./BaseUser";

/**
 * Interface đại diện cho SchoolAdmin (quản trị trường),
 * kế thừa thuộc tính từ IBaseUser.
 */
export interface ISchoolAdmin extends IBaseUser {
  // Có thể thêm thuộc tính riêng cho quản trị trường ở đây
  position: string;
}

/**
 * Schema cho SchoolAdmin
 */
const SchoolAdminSchema = new Schema<ISchoolAdmin>({
  position: { type: String, default: "Hiệu trưởng" },
});

/**
 * Tạo discriminator SchoolAdmin dựa trên BaseUser
 */
const SchoolAdmin = BaseUser.discriminator<ISchoolAdmin>(
  "SchoolAdmin",
  SchoolAdminSchema
);

export default SchoolAdmin;
