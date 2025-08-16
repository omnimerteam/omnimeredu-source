import { ExtraFeeSchema } from "./ExtraFee.schema";

// Create - bắt buộc các trường trừ _id
export const createExtraFeeBodySchema = ExtraFeeSchema.omit({
  _id: true,
});

// Update - tất cả optional
export const updateExtraFeeBodySchema = ExtraFeeSchema.partial({
  name: true,
  amount: true,
  applicableTo: true,
});
