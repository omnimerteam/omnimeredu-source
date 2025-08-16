import { z } from "zod";

/**
 * Pagination and sorting query schema
 * Example: /users?page=1&limit=10&sort=name
 */
export const paginationQuerySchema = z.object({
  page: z.coerce
    .number()
    .min(1, { message: "Số trang phải lớn hơn 0" })
    .default(1),

  limit: z.coerce
    .number()
    .min(1, { message: "Số lượng mỗi lần phải từ 1 - 50" })
    .max(50, { message: "Số lượng mỗi lần phải từ 1 - 50" })
    .default(25),
});

/**
 * Hàm tạo schema pagination + sort theo whitelist field
 * @param allowedFields Array các field được phép sort
 */
export function createPaginationSchemaWithSort(allowedFields: string[]) {
  return paginationQuerySchema.extend({
    sort: z
      .string()
      .optional()
      .refine(
        (val) => {
          if (!val) return true;
          const fields = val.split(",");
          return fields.every((f) => {
            const [field] = f.split(":");
            return allowedFields.includes(field);
          });
        },
        {
          message: `Sort chỉ được phép các field: ${allowedFields.join(", ")}`,
        }
      ),
  });
}

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
