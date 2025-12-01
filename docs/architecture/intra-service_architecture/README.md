# Clean Architecture

```
Controller (Presentation) -> UseCase (Domain) -> Repository (Domain Interface) -> Repository Implementation (Data/Infrastructure).
```

## 1. Domain Layer (Lõi Nghiệp vụ)

Lớp này chỉ chứa logic, không biết gì về framework, database (TypeORM/Prisma), hay HTTP (Express).

### A. Định nghĩa Entity và Interface Repository

**src/domain/entities/Payment.ts** (Thực thể cốt lõi, chứa dữ liệu và quy tắc nghiệp vụ cơ bản)

```typescript
// src/domain/entities/Payment.ts
export type PaymentStatus = "PENDING" | "COMPLETED" | "FAILED";

export interface Payment {
  id: string;
  studentId: string;
  amount: number;
  status: PaymentStatus;
  createdAt: Date;
  updatedAt: Date;
}
```

**src/domain/repositories/IPaymentRepository.ts** (Interface (cổng) để Domain gọi ra bên ngoài. Định nghĩa các hàm mà Domain cần.)

```typescript
// src/domain/repositories/IPaymentRepository.ts
import { Payment } from "../entities/Payment";

export interface IPaymentRepository {
  // Chức năng cần thiết cho nghiệp vụ
  create(payment: Payment): Promise<Payment>;
  updateStatus(paymentId: string, status: PaymentStatus): Promise<Payment>;
}
```

### B. Use Case (Logic Nghiệp vụ)

**src/domain/usecases/PaymentUseCase.ts** (Nơi chứa logic chính: Xử lý, tính toán, và gọi Repository Interface)

```typescript
// src/domain/usecases/payment/ProcessPaymentUseCase.ts
import { Payment } from "../../entities/Payment";
import {
  IPaymentRepository,
  PaymentStatus,
} from "../../repositories/IPaymentRepository";

interface ProcessPaymentRequest {
  studentId: string;
  amount: number;
}

export class ProcessPaymentUseCase {
  // Inject (tiêm) interface Repository (không phải implementation)
  constructor(
    private paymentRepository: IPaymentRepository // private eventPublisher: IEventPublisher // Nếu có
  ) {}

  public async execute(data: ProcessPaymentRequest): Promise<Payment> {
    // 1. Logic nghiệp vụ (ví dụ: kiểm tra số dư, xác thực...)
    if (data.amount <= 0) {
      throw new Error("Payment amount must be positive.");
    }

    // 2. Tạo đối tượng Payment ban đầu
    let newPayment: Payment = {
      id: "generated_id", // ID tạm thời
      studentId: data.studentId,
      amount: data.amount,
      status: "PENDING",
      createdAt: new Date(),
      updatedAt: new Date(),
    };

    // 3. Lưu giao dịch vào DB (gọi qua Interface)
    const createdPayment = await this.paymentRepository.create(newPayment);

    // 4. Giả lập xử lý cổng thanh toán
    // ... Logic gọi MoMo/ZaloPay API ...

    // 5. Cập nhật trạng thái
    const finalStatus: PaymentStatus = "COMPLETED";
    const updatedPayment = await this.paymentRepository.updateStatus(
      createdPayment.id,
      finalStatus
    );

    // 6. Phát hành sự kiện (Sync Mechanism)
    // await this.eventPublisher.publish('PaymentCompleted', updatedPayment);

    return updatedPayment;
  }
}
```

## 2. Data Layer (Thế giới bên ngoài/Triển khai)

Lớp này triển khai các Interface (cổng) từ Domain Layer và chứa các công nghệ ngoại vi (TypeORM/Prisma)

**src/data/repositories/PaymentRepositoryImpl.ts** (Triển khai thực tế Interface IPaymentRepository)

```typescript
// src/data/repositories/PaymentRepositoryImpl.ts
import {
  IPaymentRepository,
  PaymentStatus,
} from "../../domain/repositories/IPaymentRepository";
import { Payment } from "../../domain/entities/Payment";
// Giả sử dùng TypeORM/Prisma, đây là Model/Schema của database
import { PaymentModel } from "../datasources/postgres/PaymentModel";

// Lớp này phải implement chính xác interface từ Domain
export class PaymentRepositoryImpl implements IPaymentRepository {
  // Inject DB connection/ORM client
  constructor(private dbClient: any /* TypeORM/Prisma client */) {}

  async create(payment: Payment): Promise<Payment> {
    // Logic TypeORM: Chuyển đổi Domain Entity -> Database Model
    const dbRecord = await this.dbClient.save(PaymentModel, payment);
    // Chuyển đổi Database Model -> Domain Entity và trả về
    return dbRecord as Payment;
  }

  async updateStatus(
    paymentId: string,
    status: PaymentStatus
  ): Promise<Payment> {
    // Logic TypeORM: Tìm và cập nhật status trong DB
    const updatedRecord = await this.dbClient.update(PaymentModel, paymentId, {
      status,
      updatedAt: new Date(),
    });
    return updatedRecord as Payment;
  }
}
```

## 3. Presentation Layer (Giao diện)

Lớp này xử lý HTTP, ánh xạ yêu cầu HTTP tới Use Case.

Tệp: **src/presentation/controllers/PaymentController.ts**

```typescript
// src/presentation/controllers/PaymentController.ts
import { Request, Response } from "express";
import { ProcessPaymentUseCase } from "../../domain/usecases/payment/ProcessPaymentUseCase";

export class PaymentController {
  // Inject Use Case
  constructor(private processPaymentUseCase: ProcessPaymentUseCase) {}

  public async processPayment(req: Request, res: Response): Promise<void> {
    const { studentId, amount } = req.body;

    // 1. Xác thực/Chuyển đổi DTO (nếu cần)

    try {
      // 2. Gọi Use Case (Lõi nghiệp vụ)
      const result = await this.processPaymentUseCase.execute({
        studentId,
        amount,
      });

      // 3. Trả về kết quả HTTP
      res.status(200).json({
        message: "Payment processed successfully",
        data: result,
      });
    } catch (error: any) {
      // Xử lý lỗi
      res.status(400).json({ message: error.message });
    }
  }
}
```

## 4. Kết nối (Dependency Injection)

Đây là nơi bạn "hàn gắn" các mảnh lại với nhau, thường nằm trong **src/infrastructure/di/container.ts** hoặc tệp khởi tạo:

```typescript
// Tệp khởi tạo hoặc container DI
import { PaymentRepositoryImpl } from "../data/repositories/PaymentRepositoryImpl";
import { ProcessPaymentUseCase } from "../domain/usecases/payment/ProcessPaymentUseCase";
import { PaymentController } from "../presentation/controllers/PaymentController";

// Giả sử có DB client
const dbClient = {}; // Your TypeORM/Prisma client instance

// 1. Khởi tạo Implementation (Data Layer)
const paymentRepositoryImpl = new PaymentRepositoryImpl(dbClient);

// 2. Khởi tạo Use Case (Domain Layer) và tiêm Interface
// DÙNG IMPLEMENTATION (paymentRepositoryImpl) để đáp ứng INTERFACE (IPaymentRepository)
const processPaymentUseCase = new ProcessPaymentUseCase(paymentRepositoryImpl);

// 3. Khởi tạo Controller (Presentation Layer) và tiêm Use Case
const paymentController = new PaymentController(processPaymentUseCase);

// ... Sau đó, bạn gắn paymentController.processPayment vào Express route:
// router.post('/payments', paymentController.processPayment.bind(paymentController));
```
