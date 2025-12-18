# Phân tích và Hướng dẫn Sửa chữa Backend (`user_service`)

## 1. Phân tích Tình trạng Hiện tại

Bạn đang gặp lỗi "không thể gọi API" từ Mobile App (màn hình điểm danh giáo viên mới) vì **Backend (`user_service`) hiện chưa có các module và endpoint Attendance** mà App đang yêu cầu.

Cụ thể, `apps/mobile/lib/data/datasources/remote/attendance/attendance_remote_data_source.dart` đang gọi tới các endpoint sau (dựa trên cấu hình `endpoints.dart`):

- **POST** `/attendance/initialize`: Khởi tạo bảng điểm danh cho lớp.
- **GET** `/attendance/find`: Lấy thông tin điểm danh chi tiết (kèm danh sách học sinh và trạng thái).
- **DELETE** `/attendance/:id`: Xóa bảng điểm danh.
- **PUT** `/attendance/records/:id/status`: Cập nhật trạng thái điểm danh của từng học sinh (endpoint này trong `DetailRecord`).

Tuy nhiên, `user_service` hiện chưa implement module này.

## 2. Giải pháp Thực hiện

Bổ sung module **Attendance** vào `services/user_service`.

### Bước 1: Tạo Data Models (MongoDB)

Vì `user_service` đã cấu hình MongoDB (xem `src/server.ts`), ta sẽ dùng nó cho Attendance.

Tạo folder `src/data/models/mongodb` (nếu chưa tách biệt) hoặc dùng chung.
Tạo file `src/data/models/Attendance.ts`:

```typescript
import mongoose, { Schema, Document } from "mongoose";

export interface IAttendance extends Document {
  classId: string;
  schoolId: string;
  date: Date;
  sessionType: string;
  createdAt: Date;
  updatedAt: Date;
}

const AttendanceSchema: Schema = new Schema(
  {
    classId: { type: String, required: true },
    schoolId: { type: String, required: true },
    date: { type: Date, required: true },
    sessionType: { type: String, default: "Morning" },
  },
  { timestamps: true }
);

// Index compound để query nhanh
AttendanceSchema.index({ classId: 1, date: 1 });

export default mongoose.model<IAttendance>("Attendance", AttendanceSchema);
```

Tạo file `src/data/models/DetailRecord.ts`:

```typescript
import mongoose, { Schema, Document } from "mongoose";

export interface IDetailRecord extends Document {
  id: string;
  studentId: string;
  attendanceId: string;
  status: string;
  note?: string;
}

const DetailRecordSchema: Schema = new Schema(
  {
    studentId: { type: String, required: true }, // ID của Postgres StudentModel
    attendanceId: {
      type: Schema.Types.ObjectId,
      ref: "Attendance",
      required: true,
    },
    status: { type: String, required: true, default: "Absent" },
    note: { type: String },
  },
  { timestamps: true }
);

export default mongoose.model<IDetailRecord>(
  "DetailRecord",
  DetailRecordSchema
);
```

### Bước 2: Tạo Controller

Tạo file `src/presentation/controllers/AttendanceController.ts`.

Lưu ý: Cần join dữ liệu từ MongoDB (Attendance) và Postgres (Student, User, Class).

```typescript
import { Request, Response, NextFunction } from "express";
import Attendance from "../../data/models/Attendance";
import DetailRecord from "../../data/models/DetailRecord";
import { ClassModel } from "../../data/datasources/postgres/models/ClassModel";
import { StudentModel } from "../../data/datasources/postgres/models/StudentModel";
import { UserModel } from "../../data/datasources/postgres/models/UserModel";
import { SchoolModel } from "../../data/datasources/postgres/models/SchoolModel";

export const initializeAttendance = async (
  req: Request,
  res: Response,
  next: NextFunction
) => {
  try {
    const { classId, schoolId, date, sessionType } = req.body;

    // Chuẩn hóa date (bỏ giờ phút)
    const startDate = new Date(date);
    startDate.setHours(0, 0, 0, 0);
    const endDate = new Date(date);
    endDate.setHours(23, 59, 59, 999);

    // Kiểm tra tồn tại
    const existing = await Attendance.findOne({
      classId,
      date: { $gte: startDate, $lte: endDate },
    });
    if (existing) {
      return res.status(200).json({ success: true, data: existing });
    }

    // Tạo Attendance Master
    const newAttendance = await Attendance.create({
      classId,
      schoolId,
      date: new Date(date),
      sessionType,
    });

    // Lấy danh sách học sinh từ Postgres
    const students = await StudentModel.findAll({ where: { classId } });

    // Tạo Detail Record
    const detailRecords = students.map((student) => ({
      studentId: student.id,
      attendanceId: newAttendance._id,
      status: "Absent",
      note: "",
    }));

    if (detailRecords.length > 0) {
      await DetailRecord.insertMany(detailRecords);
    }

    res.status(201).json({ success: true, data: newAttendance });
  } catch (error) {
    next(error);
  }
};

export const getAttendanceRecordView = async (
  req: Request,
  res: Response,
  next: NextFunction
) => {
  try {
    const { classId, date } = req.query;

    const queryDate = new Date(date as string);
    const startDate = new Date(queryDate);
    startDate.setHours(0, 0, 0, 0);
    const endDate = new Date(queryDate);
    endDate.setHours(23, 59, 59, 999);

    // 1. Tìm Attendance
    const attendance = await Attendance.findOne({
      classId,
      date: { $gte: startDate, $lte: endDate },
    });

    if (!attendance) {
      return res
        .status(404)
        .json({ success: false, message: "Attendance not found" });
    }

    // 2. Lấy thông tin Class, School (Postgres)
    const classInfo = await ClassModel.findByPk(classId as string);
    const schoolInfo = await SchoolModel.findByPk(attendance.schoolId);

    // 3. Lấy Detail Records (Mongo)
    const details = await DetailRecord.find({ attendanceId: attendance._id });

    // 4. Lấy thông tin học sinh & User (Postgres)
    const studentIds = details.map((d) => d.studentId);

    // Tìm Student kèm UserInfo
    const students = await StudentModel.findAll({
      where: { id: studentIds },
      include: [{ model: UserModel, as: "user" }], // Cần đảm bảo relation alias đúng trong model init
    });
    // Nếu chưa có alias 'user', bạn cần query UserModel riêng bằng where { id: student.userId }

    // Map dữ liệu
    const studentViewModels = await Promise.all(
      students.map(async (student) => {
        const detail = details.find((d) => d.studentId === student.id);

        // Nếu không dùng include user, query user thủ công:
        const user = await UserModel.findByPk(student.userId);

        return {
          id: student.id,
          name: user?.fullName || "Unknown",
          phone: user?.phoneNumber,
          guardianName: student.guardianName,
          guardianPhone: student.guardianPhone,
          gender: user?.gender,
          birthday: user?.dateOfBirth,
          detailRecordId: detail?._id,
          status: detail?.status,
          note: detail?.note,
        };
      })
    );

    const responseData = {
      id: attendance._id,
      classId: attendance.classId,
      schoolId: attendance.schoolId,
      date: attendance.date,
      classInfo: {
        id: classInfo?.id,
        name: classInfo?.name,
        code: classInfo?.code,
      },
      schoolInfo: {
        id: schoolInfo?.id,
        name: schoolInfo?.name,
        code: schoolInfo?.code,
      },
      students: studentViewModels,
    };

    res.status(200).json({ success: true, data: responseData });
  } catch (error) {
    next(error);
  }
};

export const deleteAttendance = async (
  req: Request,
  res: Response,
  next: NextFunction
) => {
  try {
    const { id } = req.params;
    await DetailRecord.deleteMany({ attendanceId: id });
    await Attendance.findByIdAndDelete(id);
    res.status(200).json({ success: true, data: true });
  } catch (error) {
    next(error);
  }
};

export const updateDetailStatus = async (
  req: Request,
  res: Response,
  next: NextFunction
) => {
  try {
    const { id } = req.params;
    const { status, note } = req.body;
    const updated = await DetailRecord.findByIdAndUpdate(
      id,
      { status, note },
      { new: true }
    );
    res.status(200).json({ success: true, data: updated });
  } catch (error) {
    next(error);
  }
};
```

### Bước 3: Tạo Routes

File `src/presentation/routes/attendance.routes.ts`:

```typescript
import { Router } from "express";
import * as AttendanceController from "../controllers/AttendanceController";

const router = Router();

router.post("/initialize", AttendanceController.initializeAttendance);
router.get("/find", AttendanceController.getAttendanceRecordView);
router.delete("/:id", AttendanceController.deleteAttendance);
router.put("/records/:id/status", AttendanceController.updateDetailStatus);

export default router;
```

### Bước 4: Register Route

File `src/presentation/routes/index.ts`:

```typescript
import attendanceRoutes from "./attendance.routes";
// ...
router.use("/attendance", attendanceRoutes);
```

### Bước 5: Config Mobile

Đảm bảo Mobile App `.env` `PAYMENT_ATTENDANCE_SERVICE_URL` trỏ về cùng URL với `USER_SERVICE_URL` (nếu bạn chạy gộp), ví dụ `http://192.168.1.x:3001`.
