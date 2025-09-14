import { Types } from "mongoose";
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

export const searchClassesQuerySchema = z.object({
  schoolId: z
    .string()
    .refine((val) => Types.ObjectId.isValid(val), {
      message: "Dữ liệu trường học không hợp lệ",
    })
    .nullable()
    .optional(),

  query: z.string().nullable().optional(),
});

export const searchSchoolsQuerySchema = z.object({
  educationLevel: z
    .enum(["Preschool", "Primary", "Secondary", "HighSchool", "University"])
    .nullable()
    .optional(),
  query: z.string().nullable().optional(),
});

export const getSchoolAttendanceStatsSchema = z.object({
  date: z.coerce.date().optional().nullable(),
});
