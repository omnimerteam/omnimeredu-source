export interface INoSQLClient {
  connect(): Promise<void>;
  disconnect(): Promise<void>;
  create(collection: string, data: any): Promise<any>;
  read(collection: string, query: any): Promise<any[]>;
  update(collection: string, query: any, data: any): Promise<any>;
  delete(collection: string, query: any): Promise<any>;
  getClient(): any; // Return the underlying client (e.g., Mongoose instance)
}
