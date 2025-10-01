import { Types } from "mongoose";
import { z } from "zod";
import {
  EducationGradesTuple,
  EducationSystemLevelsTuple,
} from "../../../enum/educationSystemLevels.enum";

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
 * Hàm tạo schema pagination + sort + filter theo whitelist field
 * @param allowedSortFields Các field được phép sort
 * @param allowedFilterFields Các field được phép filter
 */
export function createPaginationSchemaWithSortAndFilter(
  allowedSortFields: string[],
  allowedFilterFields: string[]
) {
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
            return allowedSortFields.includes(field);
          });
        },
        {
          message: `Sort chỉ được phép các field: ${allowedSortFields.join(
            ", "
          )}`,
        }
      ),

    /**
     * filter có dạng:
     *   filter=gender:Male,literacy:Bachelor,subjects:Math|English
     */
    filter: z
      .string()
      .optional()
      .refine(
        (val) => {
          if (!val) return true;
          const fields = val.split(",");
          return fields.every((f) => {
            const [field] = f.split(":");
            return allowedFilterFields.includes(field);
          });
        },
        {
          message: `Filter chỉ được phép các field: ${allowedFilterFields.join(
            ", "
          )}`,
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
});

export const searchSchoolsQuerySchema = z.object({
  educationLevel: z.enum(EducationSystemLevelsTuple).nullable().optional(),
  query: z.string().nullable().optional(),
});

export const getSchoolAttendanceStatsSchema = z.object({
  date: z.coerce.date().optional().nullable(),
});

export const getClassAttendanceRecordView = z.object({
  date: z.coerce.date().optional().default(new Date()),
  classId: z.string().refine((val) => Types.ObjectId.isValid(val), {
    message: "Dữ liệu lớp học không hợp lệ",
  }),
});

/**
 * Hàm tạo schema pagination + sort + filter + search
 * @param allowedSortFields Các field được phép sort
 * @param allowedFilterFields Các field được phép filter
 */
export function createPaginationSchemaWithSortFilterAndSearch(
  allowedSortFields: string[],
  allowedFilterFields: string[]
) {
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
            return allowedSortFields.includes(field);
          });
        },
        {
          message: `Sort chỉ được phép các field: ${allowedSortFields.join(
            ", "
          )}`,
        }
      ),

    filter: z
      .string()
      .optional()
      .refine(
        (val) => {
          if (!val) return true;
          const fields = val.split(",");
          return fields.every((f) => {
            const [field] = f.split(":");
            return allowedFilterFields.includes(field);
          });
        },
        {
          message: `Filter chỉ được phép các field: ${allowedFilterFields.join(
            ", "
          )}`,
        }
      ),

    // 🔹 Thêm search
    search: z
      .string()
      .optional()
      .nullable()
      .refine(
        (val) => {
          if (!val) return true;
          return val.trim().length > 0; // không chấp nhận chuỗi rỗng
        },
        { message: "Search không được để trống nếu truyền vào" }
      ),
  });
}
