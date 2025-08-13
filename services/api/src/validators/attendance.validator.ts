// src/validators/attendance.validator.ts
import { z } from "zod";
import { AttendanceSchema } from "../schemas/Attendance.schema";

// ✅ Tái sử dụng phần students từ schema (nhưng bỏ optional)
const studentsRequired = AttendanceSchema.shape.students.unwrap().nonempty({
  message: "Danh sách học sinh không được để trống",
});

// ✅ Create Attendance Validator
export const createAttendanceBodySchema = AttendanceSchema.omit({
  _id: true,
}).extend({
  date: AttendanceSchema.shape.date.refine(
    (val) => new Date(val) <= new Date(),
    {
      message: "Ngày điểm danh không được lớn hơn ngày hiện tại",
    }
  ),
  students: studentsRequired, // bắt buộc và không rỗng khi create
});

// ✅ Update Attendance Validator
export const updateAttendanceBodySchema = AttendanceSchema.partial({
  classId: true,
  date: true,
  students: true,
}).extend({
  date: AttendanceSchema.shape.date
    .refine((val) => new Date(val) <= new Date(), {
      message: "Ngày điểm danh không được lớn hơn ngày hiện tại",
    })
    .optional(),
});
