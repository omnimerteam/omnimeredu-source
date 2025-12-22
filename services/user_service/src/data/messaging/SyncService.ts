import { BaseSyncService } from "shared-lib";

export class SyncService extends BaseSyncService {
  transform(data: any): any {
    // Basic transformation: remove sensitive data, format dates if needed
    // Convert PostgreSQL 'id' to MongoDB '_id'
    const { passwordHash, id, ...rest } = data;
    return {
      _id: id, // Use PostgreSQL UUID as MongoDB _id
      ...rest,
    };
  }
}
