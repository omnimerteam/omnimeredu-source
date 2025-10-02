import { Schema } from "mongoose";
import { IBaseUser } from "./BaseUser";
import BaseUser from "./BaseUser";
import {
  SubjectEnum,
  SubjectTuple,
  TeacherQualificationEnum,
  TeacherQualificationTuple,
} from "../../../common/enum/teacher.enum";

/**
 * Interface đại diện cho Teacher (giáo viên), kế thừa từ IBaseUser
 */
export interface ITeacher extends IBaseUser {
  qualification?: TeacherQualificationEnum; // Trình độ học vấn (VD: Cử nhân, Thạc sĩ)
  subjects?: SubjectEnum[]; // Danh sách môn giảng dạy (VD: Toán, Lý, Hóa)
}

/**
 * Schema cho Teacher
 */
const TeacherSchema = new Schema<ITeacher>({
  /**
   * Trình độ học vấn của giáo viên (ví dụ: Cử nhân, Thạc sĩ)
   */
  qualification: {
    type: String,
    enum: TeacherQualificationTuple,
    required: false,
  },

  /**
   * Các môn mà giáo viên giảng dạy (dạng mảng)
   */
  subjects: {
    type: [String],
    enum: SubjectTuple,
    default: [],
  },
});

/**
 * Tạo discriminator Teacher dựa trên BaseUser
 */
const Teacher = BaseUser.discriminator<ITeacher>("Teacher", TeacherSchema);

export default Teacher;
