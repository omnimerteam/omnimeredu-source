import { Schema } from "mongoose";
import { IBaseUser } from "./BaseUser";
import BaseUser from "./BaseUser";

/**
 * Interface đại diện cho Teacher (giáo viên), kế thừa từ IBaseUser
 */
export interface ITeacher extends IBaseUser {
  literacy?: string; // Trình độ học vấn (VD: Cử nhân, Thạc sĩ)
  subjects?: string[]; // Danh sách môn giảng dạy (VD: Toán, Lý, Hóa)
}

/**
 * Schema cho Teacher
 */
const TeacherSchema = new Schema<ITeacher>({
  /**
   * Trình độ học vấn của giáo viên (ví dụ: Cử nhân, Thạc sĩ)
   */
  literacy: { type: String },

  /**
   * Các môn mà giáo viên giảng dạy (dạng mảng)
   */
  subjects: { type: [String], default: [] },
});

/**
 * Tạo discriminator Teacher dựa trên BaseUser
 */
const Teacher = BaseUser.discriminator<ITeacher>("Teacher", TeacherSchema);

export default Teacher;
