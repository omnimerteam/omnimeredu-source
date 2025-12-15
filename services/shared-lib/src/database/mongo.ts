import mongoose, { Mongoose } from "mongoose";
import { INoSQLClient } from "./interfaces";

export class MongoDBClient implements INoSQLClient {
  private uri: string;
  private client: Mongoose | null = null;

  constructor(uri: string) {
    this.uri = uri;
  }

  async connect(): Promise<void> {
    try {
      this.client = await mongoose.connect(this.uri);
      console.log("Connected to MongoDB");
    } catch (error) {
      console.error("Error connecting to MongoDB", error);
      throw error;
    }
  }

  async disconnect(): Promise<void> {
    if (this.client) {
      await this.client.disconnect();
      console.log("Disconnected from MongoDB");
    }
  }

  async create(collection: string, data: any): Promise<any> {
    // In Mongoose, we typically use Models.
    // This generic implementation assumes we might pass a Model name or use a dynamic schema.
    // For simplicity in this generic wrapper, we might need a way to access models.
    // However, for a pure generic 'create', we might need to rely on the underlying driver or passed models.

    // NOTE: This generic implementation is a placeholder.
    // In practice, services will likely use Mongoose Models directly or pass the Model to a helper.
    // But to satisfy the interface for a "Client":
    if (!this.client) throw new Error("MongoDB not connected");
    const model = this.client.model(collection);
    return await model.create(data);
  }

  async read(collection: string, query: any): Promise<any[]> {
    if (!this.client) throw new Error("MongoDB not connected");
    const model = this.client.model(collection);
    return await model.find(query).exec();
  }

  async update(collection: string, query: any, data: any): Promise<any> {
    if (!this.client) throw new Error("MongoDB not connected");
    const model = this.client.model(collection);
    return await model.updateMany(query, data).exec();
  }

  async delete(collection: string, query: any): Promise<any> {
    if (!this.client) throw new Error("MongoDB not connected");
    const model = this.client.model(collection);
    return await model.deleteMany(query).exec();
  }

  getClient(): Mongoose | null {
    return this.client;
  }
}

export const mongooseInstance = mongoose;
