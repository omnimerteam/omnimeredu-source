## DISCOUNT POLICY

| Thuộc tính             | Kiểu                             | Bắt buộc     | Mô tả                                                                                                                                                                               |                                                    |
| ---------------------- | -------------------------------- | ------------ | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------- |
| `_id`                  | `ObjectId`                       | ✅           | ID tự sinh của MongoDB                                                                                                                                                              |                                                    |
| `code`                 | `string`                         | ❌           | Mã giảm giá duy nhất (ví dụ: `"DIS10OFF"`). Có `unique: true, sparse: true` nghĩa là chỉ các document có `code` mới phải duy nhất; document không có `code` thì không bị ràng buộc. |                                                    |
| `name`                 | `string`                         | ✅           | Tên hiển thị của chính sách giảm (vd: “Giảm 10% học phí tháng 9”)                                                                                                                   |                                                    |
| `description`          | `string`                         | ❌           | Mô tả chi tiết về chính sách giảm giá                                                                                                                                               |                                                    |
| `kind`                 | `DiscountKindEnum`               | ✅           | Loại giảm giá, ví dụ: `percent` (theo %) hoặc `fixed` (số tiền cố định)                                                                                                             |                                                    |
| `value`                | `number`                         | ✅           | Giá trị giảm (VD: `10` nếu là 10% hoặc `200000` nếu là 200k)                                                                                                                        |                                                    |
| `target`               | `DiscountTargetEnum`             | ❌           | Mục tiêu giảm: có thể là `Subtotal`, `ExtraFee`, hoặc `BaseFee`. Mặc định là `Subtotal`.                                                                                            |                                                    |
| `targetFeeCode`        | `string`                         | ❌           | Nếu target là `ExtraFee`, chỉ định mã phụ phí cụ thể để giảm.                                                                                                                       |                                                    |
| `maxCap`               | `number`                         | ❌           | Mức giảm tối đa (nếu giảm theo %)                                                                                                                                                   |                                                    |
| `stackable`            | `boolean`                        | ❌           | Cho phép cộng dồn với các giảm giá khác hay không                                                                                                                                   |                                                    |
| `priority`             | `number`                         | ❌           | Mức độ ưu tiên áp dụng (số lớn hơn = ưu tiên cao hơn)                                                                                                                               |                                                    |
| `exclusiveGroup`       | `string`                         | ❌           | Nhóm loại trừ — các giảm giá cùng nhóm này không thể áp dụng cùng lúc                                                                                                               |                                                    |
| `oncePer`              | `DiscountOncePerEnum`            | ❌           | Giới hạn tần suất, ví dụ: `OncePerStudent`, `OncePerInvoice`, hoặc `None`                                                                                                           |                                                    |
| `conditions`           | `Condition[]`                    | ❌           | Danh sách điều kiện áp dụng (mỗi `Condition` có thể chứa logic kiểu `minFee > 1,000,000`, `grade == “Lớp Lá”`,...)                                                                  |                                                    |
| `applicabilityScope`   | `DiscountApplicabilityScopeEnum` | ❌           | Phạm vi áp dụng: `All`, `Class`, `Student`, `Grade`                                                                                                                                 |                                                    |
| `applicableClassIds`   | `ObjectId[]`                     | ❌           | Danh sách lớp áp dụng nếu scope = `Class`                                                                                                                                           |                                                    |
| `applicableStudentIds` | `ObjectId[]`                     | ❌           | Danh sách học sinh áp dụng nếu scope = `Student`                                                                                                                                    |                                                    |
| `applicableGradeIds`   | `ObjectId[]`                     | ❌           | Danh sách khối lớp áp dụng nếu scope = `Grade`                                                                                                                                      |                                                    |
| `schoolId`             | `ObjectId`                       | ✅           | Tham chiếu đến trường (School) mà chính sách này thuộc về                                                                                                                           |                                                    |
| `active`               | `boolean`                        | ❌           | Trạng thái kích hoạt (true/false)                                                                                                                                                   |                                                    |
| `effectiveFrom`        | `Date`                           | ❌           | Ngày bắt đầu hiệu lực                                                                                                                                                               |                                                    |
| `effectiveTo`          | `Date                            | null`        | ❌                                                                                                                                                                                  | Ngày hết hiệu lực (hoặc `null` nếu không giới hạn) |
| `minSubtotal`          | `number`                         | ❌           | Tổng học phí tối thiểu để áp dụng                                                                                                                                                   |                                                    |
| `maxSubtotal`          | `number`                         | ❌           | Tổng học phí tối đa để áp dụng                                                                                                                                                      |                                                    |
| `timestamps`           | `createdAt`, `updatedAt`         | ✅ (tự sinh) | Do `timestamps: true` trong Schema                                                                                                                                                  |                                                    |

```bash
{
    "\_id": "670a2b9e3f8f28e1c2b7a100",
    "code": "DIS10SEP",
    "name": "Giảm 10% học phí tháng 9",
    "description": "Chính sách khuyến mãi cho học sinh thanh toán sớm trong tháng 9.",
    "kind": "percent",
    "value": 10,
    "target": "Subtotal",
    "targetFeeCode": null,
    "maxCap": 300000,
    "stackable": false,
    "priority": 1,
    "exclusiveGroup": "early-payment",
    "oncePer": "OncePerInvoice",
    "conditions": [
    {
    "field": "paymentDate",
    "operator": "before",
    "value": "2025-09-10"
    }
    ],
    "applicabilityScope": "Class",
    "applicableClassIds": ["670a2b9e3f8f28e1c2b7a101"],
    "applicableStudentIds": [],
    "applicableGradeIds": [],
    "schoolId": "670a2b9e3f8f28e1c2b7a000",
    "active": true,
    "effectiveFrom": "2025-09-01T00:00:00.000Z",
    "effectiveTo": "2025-09-30T23:59:59.000Z",
    "minSubtotal": 500000,
    "maxSubtotal": null,
    "createdAt": "2025-09-01T10:00:00.000Z",
    "updatedAt": "2025-09-01T10:00:00.000Z"
}
```

## EXTRA FEE

| Trường                 | Kiểu dữ liệu                     | Bắt buộc | Mô tả                                                                                                                             |                                 |
| ---------------------- | -------------------------------- | -------- | --------------------------------------------------------------------------------------------------------------------------------- | ------------------------------- |
| `_id`                  | `ObjectId`                       | ✅       | ID tự động của MongoDB                                                                                                            |                                 |
| `code`                 | `string`                         | ❌       | Mã phụ phí duy nhất (ví dụ: `"MEAL_FEE"`, `"BUS_FEE"`). Có `unique: true, sparse: true` nghĩa là chỉ cần duy nhất nếu có giá trị. |                                 |
| `name`                 | `string`                         | ✅       | Tên phụ phí hiển thị (VD: “Phí ăn trưa”, “Phí xe đưa đón”)                                                                        |                                 |
| `description`          | `string`                         | ❌       | Mô tả thêm chi tiết về phụ phí                                                                                                    |                                 |
| `calcType`             | `FeeCalcTypeEnum`                | ✅       | Cách tính phụ phí. Enum này có thể gồm: `"perStudent"`, `"perDay"`, `"perHour"`, `"perMeal"`, `"custom"`,...                      |                                 |
| `unitAmount`           | `number`                         | ❌       | Số tiền đơn vị cho mỗi đơn vị tính (VD: `20000` nếu là 20,000₫/ngày)                                                              |                                 |
| `unitName`             | `string`                         | ❌       | Đơn vị tính, ví dụ `"ngày"`, `"suất"`, `"giờ"`, `"buổi"`                                                                          |                                 |
| `conditions`           | `ICondition[]`                   | ❌       | Danh sách điều kiện áp dụng (theo `ConditionSchema`), ví dụ: chỉ áp dụng cho tháng 9, hoặc khi học sinh đăng ký bán trú           |                                 |
| `schoolId`             | `ObjectId`                       | ✅       | ID của trường mà phụ phí thuộc về                                                                                                 |                                 |
| `applicableScope`      | `ExtraFeeApplicabilityScopeEnum` | ❌       | Phạm vi áp dụng: `All`, `Class`, `Grade`, `Student`                                                                               |                                 |
| `applicableClassIds`   | `ObjectId[]`                     | ❌       | Nếu scope = `Class`, liệt kê các lớp được áp dụng                                                                                 |                                 |
| `applicableGradeIds`   | `ObjectId[]`                     | ❌       | Nếu scope = `Grade`, liệt kê các khối áp dụng                                                                                     |                                 |
| `applicableStudentIds` | `ObjectId[]`                     | ❌       | Nếu scope = `Student`, liệt kê danh sách học sinh được áp dụng                                                                    |                                 |
| `oncePer`              | `ExtraFeeOncePerEnum`            | ❌       | Xác định tần suất tính phí, ví dụ: `OncePerMonth`, `OncePerInvoice`, hoặc `None`                                                  |                                 |
| `priority`             | `number`                         | ❌       | Mức độ ưu tiên khi có nhiều phụ phí cùng điều kiện (mặc định 0)                                                                   |                                 |
| `active`               | `boolean`                        | ❌       | Phụ phí có đang hoạt động không (true/false)                                                                                      |                                 |
| `effectiveFrom`        | `Date`                           | ❌       | Ngày bắt đầu hiệu lực của phụ phí                                                                                                 |                                 |
| `effectiveTo`          | `Date                            | null`    | ❌                                                                                                                                | Ngày kết thúc hiệu lực (nếu có) |
| `formula`              | `any`                            | ❌       | Biểu thức công thức động (nếu cần tính phức tạp), ví dụ dùng **JSON Logic** hoặc custom script                                    |                                 |
| `formulaType`          | `ExtraFeeFormulaTypeEnum`        | ❌       | Loại công thức (`JsonLogic`, `Expression`, v.v.)                                                                                  |                                 |
| `isTaxable`            | `boolean`                        | ❌       | Có tính thuế VAT hay không                                                                                                        |                                 |
| `taxRate`              | `number`                         | ❌       | Tỷ lệ thuế (VD: `0.1` tương đương 10%)                                                                                            |                                 |
| `timestamps`           | tự sinh                          | ✅       | Gồm `createdAt` và `updatedAt`                                                                                                    |                                 |

```bash
{
  "_id": "670b1e8d9f2a54f89d45a900",
  "code": "MEAL_FEE",
  "name": "Phí ăn trưa",
  "description": "Phí ăn trưa áp dụng cho học sinh đăng ký bán trú.",
  "calcType": "perDay",
  "unitAmount": 25000,
  "unitName": "ngày",
  "conditions": [
    {
      "field": "isBoarding",
      "operator": "==",
      "value": true
    }
  ],
  "schoolId": "670a2b9e3f8f28e1c2b7a000",
  "applicableScope": "Class",
  "applicableClassIds": ["670b1e8d9f2a54f89d45a911"],
  "applicableGradeIds": [],
  "applicableStudentIds": [],
  "oncePer": "OncePerDay",
  "priority": 1,
  "active": true,
  "effectiveFrom": "2025-09-01T00:00:00.000Z",
  "effectiveTo": null,
  "formula": null,
  "formulaType": "JsonLogic",
  "isTaxable": false,
  "taxRate": 0,
  "createdAt": "2025-09-01T10:00:00.000Z",
  "updatedAt": "2025-09-01T10:00:00.000Z"
}

```

## Tuition

```bash
{
  "_id": "670c1234abcd5678ef901234",
  "studentId": "670b4567abcd8901ef234567",
  "schoolId": "670b0000abcd1111ef999999",
  "classId": "670b1234abcd5678ef901111",

  "periodStart": "2025-09-01T00:00:00.000Z",
  "periodEnd": "2025-09-30T00:00:00.000Z",
  "baseFeeSnapshot": 1500000,

  "extraFeeDetails": [
    {
      "feeId": "670b1e8d9f2a54f89d45a900",
      "feeCode": "MEAL_FEE",
      "feeName": "Phí ăn trưa",
      "unitAmountSnapshot": 25000,
      "quantity": 20,
      "calculatedAmount": 500000
    },
    {
      "feeId": "670b1e8d9f2a54f89d45a901",
      "feeCode": "BUS_FEE",
      "feeName": "Phí xe đưa đón",
      "unitAmountSnapshot": 300000,
      "quantity": 1,
      "calculatedAmount": 300000
    }
  ],

  "discountDetails": [
    {
      "discountId": "670b1e8d9f2a54f89d45a950",
      "discountCode": "SIBLING10",
      "discountName": "Giảm 10% cho anh chị em",
      "kind": "percentage",
      "valueSnapshot": 10,
      "appliedAmount": 230000
    }
  ],

  "appliedRules": [
    { "ruleName": "Sibling Discount", "applied": true },
    { "ruleName": "Attendance Adjustment", "applied": false }
  ],

  "calculationLog": {
    "base": 1500000,
    "extraTotal": 800000,
    "discountTotal": 230000,
    "total": 2070000
  },

  "totalAmount": 2070000,
  "attendedDays": 20,
  "currency": "VND",

  "status": "Confirmed",
  "createdBy": "670b5555abcd7777ef999111",
  "confirmedBy": "670b8888abcd9999ef777777",
  "confirmedAt": "2025-09-25T10:00:00.000Z",
  "paidAt": null,
  "invoiceId": "INV-2025-09-000123",
  "dueDate": "2025-09-30T23:59:59.000Z",
  "meta": {
    "emailSent": true,
    "autoGenerated": true
  },
  "createdAt": "2025-09-25T10:00:00.000Z",
  "updatedAt": "2025-09-25T10:00:00.000Z"
}
```
