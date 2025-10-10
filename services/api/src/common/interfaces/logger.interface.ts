export interface ILogger {
  log(options: {
    userId: string;
    action: string;
    targetId?: string;
    roleSnapshot?: string;
    metadata?: object;
  }): Promise<void>;
}
