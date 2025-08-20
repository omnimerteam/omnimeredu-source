import { Request } from "express";

export interface QueryOptions {
  page: number;
  limit: number;
  sort?: Record<string, 1 | -1>;
}
/**
 * Build query options (page, limit, sort) from request query
 * @param req Express request
 * @returns QueryOptions object
 */
export function buildQueryOptions(parsedQuery: {
  page: number;
  limit: number;
  sort?: string;
}): QueryOptions {
  const { page, limit, sort } = parsedQuery;
  const sortObj: Record<string, 1 | -1> = {}; // mặc định rỗng

  if (sort) {
    const fields = sort.split(",");
    fields.forEach((f) => {
      const [field, order] = f.split(":");
      if (field) sortObj[field] = order === "asc" ? 1 : -1;
    });
  }

  return {
    page,
    limit,
    sort: Object.keys(sortObj).length ? sortObj : undefined,
  };
}
