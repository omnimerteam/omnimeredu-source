export interface PaginationOptions {
  page?: number;
  limit?: number;
  sortBy?: string;
  sortOrder?: 'asc' | 'desc';
  cursor?: string; // For cursor-based pagination
}

export interface PaginationMetadata {
  currentPage: number;
  pageSize: number;
  totalItems: number;
  totalPages: number;
  hasNextPage: boolean;
  hasPreviousPage: boolean;
  nextPage?: number;
  previousPage?: number;
  firstPage: number;
  lastPage: number;
  cursor?: string; // Next cursor for cursor-based pagination
}

export interface PaginatedResponse<T> {
  data: T[];
  pagination: PaginationMetadata;
  filters?: any;
  sorting?: {
    field: string;
    order: 'asc' | 'desc';
  };
}

export interface CursorPaginationOptions {
  cursor?: string;
  limit?: number;
  direction?: 'forward' | 'backward';
}

export class PaginationUtil {
  /**
   * Create pagination metadata for offset-based pagination
   */
  static createMetadata(
    page: number,
    limit: number,
    totalItems: number
  ): PaginationMetadata {
    const totalPages = Math.ceil(totalItems / limit);

    return {
      currentPage: page,
      pageSize: limit,
      totalItems,
      totalPages,
      hasNextPage: page < totalPages,
      hasPreviousPage: page > 1,
      nextPage: page < totalPages ? page + 1 : undefined,
      previousPage: page > 1 ? page - 1 : undefined,
      firstPage: 1,
      lastPage: totalPages || 1
    };
  }

  /**
   * Parse and validate pagination options
   */
  static parseOptions(options: PaginationOptions): {
    page: number;
    limit: number;
    sortBy: string;
    sortOrder: 'asc' | 'desc';
    offset: number;
  } {
    const page = Math.max(1, parseInt(String(options.page || 1)));
    const limit = Math.min(100, Math.max(1, parseInt(String(options.limit || 20))));
    const sortBy = options.sortBy || 'createdAt';
    const sortOrder = (options.sortOrder || 'desc') as 'asc' | 'desc';
    const offset = (page - 1) * limit;

    return {
      page,
      limit,
      sortBy,
      sortOrder,
      offset
    };
  }

  /**
   * Generate cursor for cursor-based pagination
   */
  static generateCursor(item: any, sortField: string): string {
    const value = item[sortField];
    const timestamp = item.createdAt || new Date();
    return Buffer.from(`${value}|${timestamp.getTime()}`).toString('base64');
  }

  /**
   * Decode cursor for cursor-based pagination
   */
  static decodeCursor(cursor: string): { value: any; timestamp: number } | null {
    try {
      const decoded = Buffer.from(cursor, 'base64').toString('utf-8');
      const [value, timestamp] = decoded.split('|');
      return {
        value: value,
        timestamp: parseInt(timestamp)
      };
    } catch {
      return null;
    }
  }

  /**
   * Build order clause for Sequelize based on pagination options
   */
  static buildOrderClause(sortBy: string, sortOrder: 'asc' | 'desc'): Array<[string, string]> {
    // Always include id as secondary sort for consistent ordering
    return [
      [sortBy, sortOrder.toUpperCase() as 'ASC' | 'DESC'],
      ['id', sortOrder.toUpperCase() as 'ASC' | 'DESC']
    ];
  }

  /**
   * Create response with pagination
   */
  static createResponse<T>(
    data: T[],
    totalItems: number,
    options: PaginationOptions,
    filters?: any
  ): PaginatedResponse<T> {
    const { page, limit, sortBy, sortOrder } = this.parseOptions(options);
    const pagination = this.createMetadata(page, limit, totalItems);

    return {
      data,
      pagination,
      filters,
      sorting: {
        field: sortBy,
        order: sortOrder
      }
    };
  }
}