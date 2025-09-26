export class HttpError extends Error {
  status: number;
  code?: string;

  constructor(status: number, message: string, code?: string) {
    super(message);
    this.status = status;
    this.code = code;

    // Giữ stack trace gốc khi extend từ Error
    Object.setPrototypeOf(this, HttpError.prototype);
  }
}
