import { z } from "zod";
import { PaymentMethodSchema } from "../schemas/PaymentMethod.schema";

// Schema tạo mới
export const createPaymentMethodBodySchema = PaymentMethodSchema.omit({
  _id: true,
}).extend({
  name: PaymentMethodSchema.shape.name, // giữ nguyên enum đã định nghĩa
  description: PaymentMethodSchema.shape.description,
});

// Schema cập nhật
export const updatePaymentMethodBodySchema = PaymentMethodSchema.partial({
  name: true,
  description: true,
}).extend({
  name: PaymentMethodSchema.shape.name.optional(),
  description: PaymentMethodSchema.shape.description.optional(),
});
