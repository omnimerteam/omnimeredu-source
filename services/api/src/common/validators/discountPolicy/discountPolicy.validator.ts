import { DiscountPolicySchema } from "./DiscountPolicy.schema";

// Create - bắt buộc tất cả trường trừ _id
export const createDiscountPolicyBodySchema = DiscountPolicySchema.omit({
  _id: true,
});

// Update - tất cả optional
export const updateDiscountPolicyBodySchema = DiscountPolicySchema.partial({
  name: true,
  type: true,
  value: true,
  applicableTo: true,
});
