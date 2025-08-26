import { z } from "zod";

export const authHeaderSchema = z.object({
  authorization: z
    .string()
    .regex(/^Bearer\s+[A-Za-z0-9\-_]+\.[A-Za-z0-9\-_]+\.[A-Za-z0-9\-_]+$/, {
      message: "Authorization header phải có dạng Bearer <JWT>",
    })
    .refine((val) => !/[\r\n\t]/.test(val), {
      message: "Authorization header chứa ký tự không hợp lệ",
    })
    .transform((val) => val.trim()),
});
