export class HttpError extends Error {
  status: number;
  code?: string;
  errorData?: any;

  constructor(status: number, message: string, code?: string, errorData?: any) {
    super(message);
    this.status = status;
    this.code = code;
    this.errorData = errorData;

    // Giữ stack trace gốc khi extend từ Error
    Object.setPrototypeOf(this, HttpError.prototype);
  }
}
