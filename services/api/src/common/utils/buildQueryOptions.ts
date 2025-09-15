export interface PaginationQueryOptions {
  page: number;
  limit: number;
  sort?: Record<string, 1 | -1>;
  filter?: Record<string, any>; // thêm filter
}
/**
 * Build query options (page, limit, sort, filter) từ request query
 * @param parsedQuery object từ req.query
 * @returns QueryOptions object
 */
export function buildQueryOptions(parsedQuery: {
  page: number;
  limit: number;
  sort?: string;
  filter?: string; // dạng: "gender:Male,literacy:Bachelor,subjects:Math|English"
}): PaginationQueryOptions {
  const { page, limit, sort, filter } = parsedQuery;

  // 🔹 Xử lý sort
  const sortObj: Record<string, 1 | -1> = {};
  if (sort) {
    const fields = sort.split(",");
    fields.forEach((f) => {
      const [field, order] = f.split(":");
      if (field) sortObj[field] = order === "asc" ? 1 : -1;
    });
  }

  // 🔹 Xử lý filter
  const filterObj: Record<string, any> = {};
  if (filter) {
    const fields = filter.split(",");
    fields.forEach((f) => {
      const [key, value] = f.split(":");
      if (!key || !value) return;

      // Nếu có nhiều giá trị (dùng |), thì dùng $in
      if (value.includes("|")) {
        filterObj[key] = { $in: value.split("|").map((v) => v.trim()) };
      } else {
        filterObj[key] = value.trim();
      }
    });
  }

  return {
    page,
    limit,
    sort: Object.keys(sortObj).length ? sortObj : undefined,
    filter: Object.keys(filterObj).length ? filterObj : undefined,
  };
}
