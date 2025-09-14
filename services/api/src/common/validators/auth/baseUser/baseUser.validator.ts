import { z } from "zod";
import { BaseUserSchema } from "./BaseUser.schema";

// ✅ Create User Validator
export const createBaseUserBodySchema = BaseUserSchema.omit({
  _id: true,
}).extend({
  fullName: BaseUserSchema.shape.fullName,
  roleId: BaseUserSchema.shape.roleId,
  birthday: BaseUserSchema.shape.birthday.refine(
    (val) => !val || new Date(val) <= new Date(),
    {
      message: "Ngày sinh không được lớn hơn ngày hiện tại",
    }
  ),
});

// ✅ Update User Validator
export const updateBaseUserBodySchema = BaseUserSchema.partial().extend({
  birthday: BaseUserSchema.shape.birthday
    .refine((val) => !val || new Date(val) <= new Date(), {
      message: "Ngày sinh không được lớn hơn ngày hiện tại",
    })
    .optional(),
});
