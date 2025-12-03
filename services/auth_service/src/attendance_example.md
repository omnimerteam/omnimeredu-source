# Ví dụ Triển khai CQRS: Điểm danh (Attendance)

Tài liệu này minh họa cách áp dụng kiến trúc **Clean Architecture + CQRS** cho tính năng Điểm danh, với luồng dữ liệu từ **RDS (PostgreSQL)** sang **MongoDB**.

## 1. Dữ liệu Mục tiêu

Chúng ta sẽ xử lý dữ liệu điểm danh với cấu trúc Read Model (MongoDB) như sau:

```json
{
  "attendance": {
    "student": {
      "id": "S12345",
      "name": "Nguyen Van A",
      "class": "12A1"
    },
    "qr_code": {
      "id": "QR98765",
      "location": {
        "latitude": 10.762622,
        "longitude": 106.660172
      },
      "valid_radius_meters": 50
    },
    "student_location": {
      "latitude": 10.7627,
      "longitude": 106.6602
    },
    "status": "pending", // hoặc "success", "failed"
    "timestamp": "2025-12-03T23:15:00+07:00"
  }
}
```

---

## 2. Command Side (Write - RDS PostgreSQL)

Ở phía Command, chúng ta ưu tiên tính toàn vẹn và chuẩn hóa dữ liệu (Normalization). Dữ liệu sẽ được lưu vào các bảng quan hệ.

### 2.1. SQL Schema (Sequelize Models)

Chúng ta không lưu lặp lại thông tin sinh viên hay QR code trong bảng `Attendance`, mà chỉ lưu khóa ngoại (Foreign Keys).

```typescript
// infrastructure/database/sql/models/AttendanceModel.ts
import { Model, DataTypes } from "sequelize";
import sequelize from "../config";

class AttendanceModel extends Model {}

AttendanceModel.init(
  {
    id: {
      type: DataTypes.UUID,
      defaultValue: DataTypes.UUIDV4,
      primaryKey: true,
    },
    student_id: {
      type: DataTypes.STRING,
      allowNull: false,
      // References StudentModel
    },
    qr_code_id: {
      type: DataTypes.STRING,
      allowNull: false,
      // References QrCodeModel
    },
    student_lat: {
      type: DataTypes.FLOAT,
      allowNull: false,
    },
    student_lon: {
      type: DataTypes.FLOAT,
      allowNull: false,
    },
    status: {
      type: DataTypes.ENUM("pending", "success", "failed"),
      defaultValue: "pending",
    },
    check_in_time: {
      type: DataTypes.DATE,
      defaultValue: DataTypes.NOW,
    },
  },
  {
    sequelize,
    tableName: "attendances",
  }
);

export default AttendanceModel;
```

### 2.2. Use Case: Xử lý Điểm danh (SubmitAttendanceUseCase)

Use Case này chứa logic nghiệp vụ, ghi vào SQL và bắn Event.

```typescript
// application/use_cases/command/SubmitAttendanceUseCase.ts
export class SubmitAttendanceUseCase {
  constructor(
    private attendanceRepo: IAttendanceCommandRepository,
    private studentRepo: IStudentRepository, // Để lấy info validate
    private qrRepo: IQrCodeRepository, // Để lấy info validate
    private eventPublisher: IEventPublisher
  ) {}

  async execute(input: SubmitAttendanceDTO): Promise<void> {
    // 1. Validate Business Logic
    const qrCode = await this.qrRepo.findById(input.qrCodeId);
    if (!qrCode) throw new Error("Invalid QR Code");

    // Tính khoảng cách (Haversine formula)
    const distance = calculateDistance(
      input.latitude,
      input.longitude,
      qrCode.latitude,
      qrCode.longitude
    );

    const status = distance <= qrCode.validRadius ? "success" : "failed";

    // 2. Write to RDS (SQL) - Chỉ lưu data cần thiết
    const newAttendance = await this.attendanceRepo.create({
      studentId: input.studentId,
      qrCodeId: input.qrCodeId,
      studentLat: input.latitude,
      studentLon: input.longitude,
      status: status,
      timestamp: new Date(),
    });

    // 3. Publish Domain Event
    // Event chứa ID để Worker có thể query lại, hoặc chứa full data nếu muốn giảm tải query
    const event = new AttendanceSubmittedEvent({
      attendanceId: newAttendance.id,
      studentId: input.studentId,
      qrCodeId: input.qrCodeId,
      status: status,
      timestamp: newAttendance.timestamp,
    });

    await this.eventPublisher.publish("attendance.submitted", event);
  }
}
```

---

## 3. Sync Mechanism (Worker)

Worker lắng nghe sự kiện, tổng hợp dữ liệu từ các bảng SQL (Enrichment) để tạo ra bản ghi đầy đủ cho MongoDB.

```typescript
// infrastructure/messaging/consumer/AttendanceSyncWorker.ts
export class AttendanceSyncWorker {
  constructor(
    private attendanceQueryRepo: IAttendanceQueryRepository, // Mongo Repo
    private studentRepo: IStudentRepository, // SQL Repo (để lấy name, class)
    private qrRepo: IQrCodeRepository // SQL Repo (để lấy location, radius)
  ) {}

  async handle(event: AttendanceSubmittedEvent) {
    // 1. Data Enrichment (Lấy thông tin chi tiết từ SQL/Cache)
    // Vì SQL lưu chuẩn hóa (chỉ có ID), ta cần query để lấy name, class, location...
    const student = await this.studentRepo.findById(event.studentId);
    const qrCode = await this.qrRepo.findById(event.qrCodeId);

    if (!student || !qrCode) {
      console.error("Data inconsistency detected");
      return;
    }

    // 2. Construct Read Model (Denormalized Data)
    // Đây chính là cấu trúc JSON mà Client cần đọc nhanh
    const attendanceReadModel = {
      attendance: {
        student: {
          id: student.id,
          name: student.name,
          class: student.class,
        },
        qr_code: {
          id: qrCode.id,
          location: {
            latitude: qrCode.latitude,
            longitude: qrCode.longitude,
          },
          valid_radius_meters: qrCode.validRadius,
        },
        student_location: {
          latitude: event.studentLat, // Lấy từ event hoặc query lại SQL attendance
          longitude: event.studentLon,
        },
        status: event.status,
        timestamp: event.timestamp,
      },
    };

    // 3. Save to MongoDB
    await this.attendanceQueryRepo.save(attendanceReadModel);
    console.log("Synced attendance to MongoDB");
  }
}
```

---

## 4. Query Side (Read - MongoDB)

Phía Query cực kỳ đơn giản và nhanh, chỉ việc đọc document đã được chuẩn bị sẵn.

### 4.1. Mongoose Schema

```typescript
// infrastructure/database/nosql/schemas/AttendanceReadSchema.ts
import mongoose from "mongoose";

const AttendanceReadSchema = new mongoose.Schema({
  attendance: {
    student: {
      id: String,
      name: String,
      class: String,
    },
    qr_code: {
      id: String,
      location: {
        latitude: Number,
        longitude: Number,
      },
      valid_radius_meters: Number,
    },
    student_location: {
      latitude: Number,
      longitude: Number,
    },
    status: String,
    timestamp: Date,
  },
});

// Index để search nhanh
AttendanceReadSchema.index({ "attendance.student.id": 1 });
AttendanceReadSchema.index({ "attendance.timestamp": -1 });

export const AttendanceReadModel = mongoose.model(
  "Attendance",
  AttendanceReadSchema
);
```

### 4.2. Use Case: Xem Lịch sử (GetAttendanceHistoryUseCase)

```typescript
// application/use_cases/query/GetAttendanceHistoryUseCase.ts
export class GetAttendanceHistoryUseCase {
  constructor(private attendanceQueryRepo: IAttendanceQueryRepository) {}

  async execute(studentId: string): Promise<any> {
    // Đọc trực tiếp từ Mongo, không cần JOIN, không cần tính toán
    return await this.attendanceQueryRepo.findByStudentId(studentId);
  }
}
```

## 5. Tổng kết Luồng đi

1.  **Client** gửi tọa độ -> **API**.
2.  **Command UseCase**:
    - Tính toán khoảng cách.
    - Ghi `status`, `lat`, `lon` vào **PostgreSQL** (Bảng `attendances`).
    - Bắn event `AttendanceSubmitted`.
3.  **Worker**:
    - Nhận event.
    - Query thêm thông tin `name`, `class` từ SQL `students`.
    - Query thêm thông tin `qr_location` từ SQL `qr_codes`.
    - Gộp lại thành JSON to.
    - Lưu vào **MongoDB**.
4.  **Client** xem lịch sử -> **Query UseCase** đọc **MongoDB** trả về ngay lập tức.
