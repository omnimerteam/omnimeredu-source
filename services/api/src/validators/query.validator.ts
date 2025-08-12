import { z } from "zod";

/**
 * Pagination and sorting query schema
 * Example: /users?page=1&limit=10&sort=name
 */
export const paginationQuerySchema = z.object({
  page: z
    .string()
    .optional()
    .transform((val) => (val ? parseInt(val, 10) : 1))
    .refine((val) => val > 0, { message: "Số trang phải lớn hơn 0" }),

  limit: z
    .string()
    .optional()
    .transform((val) => (val ? parseInt(val, 10) : 25))
    .refine((val) => val > 0 && val <= 50, {
      message: "Số lượng mỗi lần phản từ 1 - 50",
    }),

  sort: z.enum(["name", "createdAt", "updatedAt"]).optional(),
});

/**
 * User search query schema
 * Example: /users?keyword=abc&role=admin&page=1
 */
export const userSearchQuerySchema = paginationQuerySchema.extend({
  keyword: z.string().optional(),
  role: z.enum(["admin", "teacher", "student"]).optional(),
});

/**
 * Class filter query schema
 * Example: /classes?schoolId=...&teacherId=...
 */
export const classFilterQuerySchema = paginationQuerySchema.extend({
  schoolId: z.string().optional(),
  teacherId: z.string().optional(),
});
