import { INoSQLClient } from "./interfaces";

export interface ISyncService {
  sync(
    data: any,
    operation: "CREATE" | "UPDATE" | "DELETE",
    collection: string
  ): Promise<void>;
}

export abstract class BaseSyncService implements ISyncService {
  protected noSQLClient: INoSQLClient;

  constructor(noSQLClient: INoSQLClient) {
    this.noSQLClient = noSQLClient;
  }

  abstract transform(data: any): any;

  async sync(
    data: any,
    operation: "CREATE" | "UPDATE" | "DELETE",
    collection: string
  ): Promise<void> {
    const transformedData = this.transform(data);

    switch (operation) {
      case "CREATE":
        await this.noSQLClient.create(collection, transformedData);
        break;
      case "UPDATE":
        // Assuming data has an 'id' or unique identifier for query
        await this.noSQLClient.update(
          collection,
          { id: data.id },
          transformedData
        );
        break;
      case "DELETE":
        await this.noSQLClient.delete(collection, { id: data.id });
        break;
    }
  }
}
