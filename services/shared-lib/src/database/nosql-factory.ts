import { INoSQLClient } from "./interfaces";
import { MongoDBClient } from "./mongo";

export enum NoSQLType {
  MONGODB = "MONGODB",
  DYNAMODB = "DYNAMODB",
}

export class NoSQLClientFactory {
  static createClient(type: NoSQLType, uri: string): INoSQLClient {
    switch (type) {
      case NoSQLType.MONGODB:
        return new MongoDBClient(uri);
      case NoSQLType.DYNAMODB:
        throw new Error("DynamoDB client not implemented yet");
      default:
        throw new Error("Unsupported NoSQL type");
    }
  }
}
