import { DiscountPolicyZodSchema } from "./DiscountPolicy.schema";

// Create - bắt buộc tất cả trường trừ _id
export const createDiscountPolicyBodySchema = DiscountPolicyZodSchema.omit({
  _id: true,
});

// Update - tất cả optional
export const updateDiscountPolicyBodySchema = DiscountPolicyZodSchema.partial();
