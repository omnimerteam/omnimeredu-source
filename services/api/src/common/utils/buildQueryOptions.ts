export interface PaginationQueryOptions {
  page: number;
  limit: number;
  sort?: Record<string, 1 | -1>;
  filter?: Record<string, any>;
  search?: string;
}

/**
 * Build query options (page, limit, sort, filter, search) từ request query
 */
export function buildQueryOptions(parsedQuery: {
  page: number;
  limit: number;
  sort?: string | null;
  filter?: string | null; // "gender:Male,literacy:Bachelor,subjects:Math|English"
  search?: string | null; // ?search=John
}): PaginationQueryOptions {
  const { page, limit } = parsedQuery;

  // 🔹 Xử lý sort
  let sortObj: Record<string, 1 | -1> | undefined;
  if (parsedQuery.sort && parsedQuery.sort !== "null") {
    const fields = parsedQuery.sort.split(",");
    const obj: Record<string, 1 | -1> = {};
    fields.forEach((f) => {
      const [field, order] = f.split(":");
      if (field) obj[field] = order === "asc" ? 1 : -1;
    });
    if (Object.keys(obj).length) sortObj = obj;
  }

  // 🔹 Xử lý filter
  let filterObj: Record<string, any> | undefined;
  if (parsedQuery.filter && parsedQuery.filter !== "null") {
    const fields = parsedQuery.filter.split(",");
    const obj: Record<string, any> = {};
    fields.forEach((f) => {
      const [key, value] = f.split(":");
      if (!key || !value || value === "null") return;

      if (value.includes("|")) {
        obj[key] = { $in: value.split("|").map((v) => v.trim()) };
      } else {
        obj[key] = value.trim();
      }
    });
    if (Object.keys(obj).length) filterObj = obj;
  }

  // 🔹 Xử lý search
  const search =
    parsedQuery.search && parsedQuery.search !== "null"
      ? parsedQuery.search.trim()
      : undefined;

  return {
    page,
    limit,
    sort: sortObj,
    filter: filterObj,
    search,
  };
}
