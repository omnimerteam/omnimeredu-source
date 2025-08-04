import { z } from "zod";
import { Types } from "mongoose";

export const AccountSchema = z.object({
  _id: z
    .string()
    .refine((val) => Types.ObjectId.isValid(val), {
      message: "Định dạng ObjectId không hợp lệ cho _id",
    })
    .optional(),

  email: z.string().email({ message: "Email không hợp lệ" }),

  password: z.string(),

  uid: z.string(),

  token: z.string().optional(),

  userId: z.string().refine((val) => Types.ObjectId.isValid(val), {
    message: "Định dạng ObjectId không hợp lệ cho userId",
  }),
});

export type Account = z.infer<typeof AccountSchema>;
