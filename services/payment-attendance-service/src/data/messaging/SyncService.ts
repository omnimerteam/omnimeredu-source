import { Connection } from "mongoose";

export class SyncService {
  constructor(private mongoConnection: Connection) {}

  async sync(
    data: any,
    operation: "CREATE" | "UPDATE" | "DELETE",
    collectionName: string
  ) {
    try {
      const collection = this.mongoConnection.collection(collectionName);
      const id = data.id;

      switch (operation) {
        case "CREATE":
        case "UPDATE":
          // Upsert: insert if not exists, update if exists
          await collection.updateOne(
            { _id: id },
            { $set: { ...data, _id: id } },
            { upsert: true }
          );
          break;

        case "DELETE":
          await collection.deleteOne({ _id: id });
          break;

        default:
          console.warn(`Unknown operation: ${operation}`);
      }
    } catch (error) {
      console.error(`Sync error for ${collectionName}:`, error);
      throw error;
    }
  }
}
