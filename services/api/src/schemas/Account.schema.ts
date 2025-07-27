import { z } from "zod";
import { Types } from "mongoose";

export const AccountSchema = z.object({
  _id: z
    .string()
    .refine((val) => Types.ObjectId.isValid(val), {
      message: "Invalid ObjectId format for _id",
    })
    .optional(), // MongoDB tự sinh, không cần validate trên FE
  email: z
    .string()
    .email({ message: "Invalid email format" })
    .min(1, { message: "Email is required" }), // Bắt buộc, thông báo lỗi nếu thiếu
  password: z
    .string()
    .min(8, { message: "Password must be at least 8 characters long" })
    .regex(
      /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$/,
      {
        message:
          "Password must contain at least one uppercase letter, one lowercase letter, one number, and one special character",
      }
    ), // Bắt buộc, thông báo lỗi nếu thiếu
  uid: z
    .string()
    .min(1, { message: "UID is required" })
    .regex(
      /^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i,
      {
        message: "Invalid UUID v4 format",
      }
    ), // Bắt buộc, thông báo lỗi nếu thiếu
  token: z
    .string()
    .optional()
    .refine(
      (val) =>
        !val || /^[A-Za-z0-9-_]+\.[A-Za-z0-9-_]+\.[A-Za-z0-9-_]+$/.test(val),
      { message: "Invalid JWT format" }
    ),
  refreshToken: z.string().optional(),
  userId: z
    .string()
    .min(1, { message: "userId is required" })
    .refine((val) => Types.ObjectId.isValid(val), {
      message: "Invalid ObjectId format for userId",
    }), // Bắt buộc, thông báo lỗi nếu thiếu
});

export type Account = z.infer<typeof AccountSchema>;
export const CreateAccountSchema = AccountSchema.omit({ _id: true });
export const UpdateAccountSchema = AccountSchema.partial({
  email: true,
  password: true,
  uid: true,
  token: true,
  refreshToken: true,
  userId: true,
});
