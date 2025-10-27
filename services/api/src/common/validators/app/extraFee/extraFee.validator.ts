import { ExtraFeeZodSchema } from "./ExtraFee.schema";

// Create - bắt buộc các trường trừ _id
export const createExtraFeeBodySchema = ExtraFeeZodSchema.omit({
  _id: true,
});

// Update - tất cả optional
export const updateExtraFeeBodySchema = ExtraFeeZodSchema.partial();
