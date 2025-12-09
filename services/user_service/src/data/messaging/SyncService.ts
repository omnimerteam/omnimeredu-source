import { BaseSyncService } from "shared-lib";

export class SyncService extends BaseSyncService {
  transform(data: any): any {
    // Basic transformation: remove sensitive data, format dates if needed
    // For now, return data as is, but ensure IDs are strings if needed by Mongo
    const { passwordHash, ...rest } = data;
    return rest;
  }
}
