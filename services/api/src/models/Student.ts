import { Schema, Types } from "mongoose";
import { IBaseUser } from "./BaseUser";
import BaseUser from "./BaseUser";

/**
 * Interface đại diện cho Student (học sinh), kế thừa từ IBaseUser
 */
export interface IStudent extends IBaseUser {
  classId?: Types.ObjectId; // ID lớp mà học sinh thuộc về
  guardianName?: string; // Tên phụ huynh
  guardianPhone?: string; // Số điện thoại phụ huynh
  educationLevel: "Preschool" | "Primary" | "Secondary" | "HighSchool"; // Cấp học
  grade?: string; // Khối hoặc lớp (ví dụ: "1", "5", "10A1")
}

/**
 * Schema cho Student
 */
const StudentSchema = new Schema<IStudent>({
  /**
   * Liên kết tới lớp mà học sinh đang học
   */
  classId: { type: Schema.Types.ObjectId, ref: "Class", required: false },

  /**
   * Thông tin phụ huynh
   */
  guardianName: { type: String },
  guardianPhone: { type: String },

  /**
   * Cấp học: Mầm non, Tiểu học, Trung học cơ sở, Trung học phổ thông
   */
  educationLevel: {
    type: String,
    enum: ["Preschool", "Primary", "Secondary", "HighSchool"],
    required: true,
  },

  /**
   * Khối hoặc lớp
   */
  grade: { type: String },
});

/**
 * Tạo discriminator Student dựa trên BaseUser
 */
const Student = BaseUser.discriminator<IStudent>("Student", StudentSchema);

export default Student;
